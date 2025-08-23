## Caffeine 缓存框架介绍

Caffeine是一个**Java高性能的==本地==缓存库**。和ConcurrentMap一样支持并发(意味着它可以安全地在多线程环境中使用，允许多个线程同时对缓存进行读取和写入操作),并且支持0(1)时间复杂度的数据存取。二者的主要区别在于：

- ConcurrentMap将存储所有入的数据，**直到你手动将其移除**；
-  Caffeine将通过添加相关**移除和过期策略**，自动移除“不常用”的数据，以保持内存的合理占用。

Caffeine的底层数据存储采用ConcurrentHashMap,因此,一种更好的理解方式是：Cache是一种带有存储和移除策略的Map。

**优点**：相对于分布式缓存，**本地缓存访问速度更快**，使用本地缓存能够减少和`Redis`类的远程缓存间的数据交互，**减少网络I/O开销**，降低这一过程中在网络通信上的耗时

**缺点**：由于是本地缓存,在分布式系统下由于有多个节点的本地缓存,所以要考虑**跨节点缓存的场景**,**通常就是需要结合其他分布式缓存方案**。比如我项目里用到的 MQ 加 Redis 的方案.

## springboot项目集成Caffeine缓存框架

##### 导入依赖

```xml
<dependency>
    <groupId>com.github.ben-manes.caffeine</groupId>
    <artifactId>caffeine</artifactId>
    <version>3.1.6</version> <!-- 使用最新版本 -->
</dependency>
```

##### 直接使用

```java
@Slf4j
@Component
@Lazy
public class MessageConsumer {
    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private TopicMessageProducer topicMessageProducer;

    // 使用Caffeine缓存替换原来的ConcurrentHashMap
    private final Cache<Long, SseEmitter> driverEmitters;
    private final Cache<Long, SseEmitter> userEmitters;
    @Autowired
    public MessageConsumer() {
        // 初始化Caffeine缓存
        this.driverEmitters = Caffeine.newBuilder()
                .maximumSize(1000) // 设置最大缓存数量
                .expireAfterAccess(1, TimeUnit.HOURS) // 1小时未访问则过期
                .removalListener((Long key, SseEmitter emitter, RemovalCause cause) -> {
                    if (key != null) {
                        redisTemplate.opsForHash().delete(DRIVER_EMITTERS_KEYS, key);
                        log.info("Driver emitter removed from cache and Redis. Key: {}, Cause: {}", key, cause);
                    }
                })
                .build();

        this.userEmitters = Caffeine.newBuilder()
                .maximumSize(1000) // 设置最大缓存数量
                .expireAfterAccess(1, TimeUnit.HOURS) // 1小时未访问则过期
                .removalListener((Long key, SseEmitter emitter, RemovalCause cause) -> {
                    if (key != null) {
                        redisTemplate.opsForHash().delete(PASSENGER_EMITTERS_KEYS, key);
                        log.info("User emitter removed from cache and Redis. Key: {}, Cause: {}", key, cause);
                    }
                })
                .build();
    }


    // 向客户发送验时订单
    @RabbitListener(queues = RabbitMQTopicConfig.DELAY_ORDER_QUEUE_NAME)
    public void processDelayMessage(Long orderId) {
        log.info("收到延迟消息，订单ID: {}", orderId);
        // 查询订单信息
        Integer orderStatus = orderMapper.getStatus(orderId);
        Long passengerId = orderMapper.getPassengerId(orderId);
        if (orderStatus == null) {
            log.warn("订单id为: {}！！！", orderId);
            return;
        }
        if(!orderStatus.equals(0)){ // 已下单 --> 订单已超时未接单-->取消订单
            return;
        }
        // 自动取消订单
        LambdaUpdateWrapper<Order> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(Order::getId, orderId)
                .eq(Order::getStatus, 0)
                .set(Order::getStatus, 3);
        Integer updateRow = orderMapper.update(null, updateWrapper);
        if(updateRow.equals(0)){
            log.warn("订单id为: {}！！！", orderId);
            return;
        }
        // 发送消息给乘客
        topicMessageProducer.sendMessageToPassenger(passengerId, "订单已超时未接单，请重新下单！");
    }

    /**
     * 根据redisEmitterKey获取对应的Cache对象
     *
     * @param redisEmitterKey
     * @return Cache<Long, SseEmitter>
     */
    private Cache<Long, SseEmitter> getCacheByKey(String redisEmitterKey) {
        if (redisEmitterKey.equals(DRIVER_EMITTERS_KEYS)) {
            return driverEmitters;
        } else if (redisEmitterKey.equals(PASSENGER_EMITTERS_KEYS)) {
            return userEmitters;
        }
        return null;
    }


    /**
     * 订阅sse，创建连接通道
     * @param id
     * @param redisEmitterKey
     * @return
     */
    public SseEmitter subscribe(Long id, String redisEmitterKey) {
        // 获取对应的缓存
        Cache<Long, SseEmitter> cache = getCacheByKey(redisEmitterKey);
        if (cache == null) {
            throw new IllegalArgumentException("Invalid redisEmitterKey: " + redisEmitterKey);
        }
        // 从缓存中获取或创建Emitter
        return cache.get(id, key -> { // key就是id
            SseEmitter sseEmitter = new SseEmitter(3600000L);
            sseEmitter.onCompletion(() -> {
                log.info("SSE连接已完成/关闭，ID: {}", key);
            });

            sseEmitter.onTimeout(() -> {
                cache.invalidate(key);
                redisTemplate.opsForHash().delete(redisEmitterKey, id);
                log.warn("SSE连接超时，ID: {}", key);
            });

            sseEmitter.onError(ex -> {
                cache.invalidate(key);
                redisTemplate.opsForHash().delete(redisEmitterKey, key);
                log.error("SSE连接发生错误，ID: {}，错误信息: {}", key, ex.getMessage());
            });

            // 将新的Emitter信息存入Redis
            redisTemplate.opsForHash().put(redisEmitterKey, key, RabbitMQTopicConfig.Port);
            log.info("连接id为{}的节点端口号为{}", key, RabbitMQTopicConfig.Port);
            return sseEmitter;
        });
    }


    /**
     * 接收消息并通过sse推送消息
     * @param request
     */
    @RabbitListener(queues = "#{@topicQueue.name}")
    public void sendSse(@Payload MqRequest request) {
        Long id = request.getId();
        Byte type = request.getType();

        Cache<Long, SseEmitter> cache = type.equals((byte) 1) ? driverEmitters :
                type.equals((byte) 0) ? userEmitters : null;

        if (cache == null) {
            log.warn("无效的 type 值: {}", type);
            return;
        }

        SseEmitter sseEmitter = cache.getIfPresent(id); // 存在为sseEmitter，不存在为null
        if (sseEmitter == null) {
            log.warn("没有找到sseEmitter for ID: {}", id);
            return;
        }

        try {
            SseEmitter.SseEventBuilder event = SseEmitter.event()
                    .data("sse连接，推送成功，id为" + id + ",消息为" + request.getMessage());
            sseEmitter.send(event);
            log.debug("成功推送消息给ID: {}", id);
        } catch (IOException e) {
            log.error("推送消息给ID: {} 失败", id, e);
            cache.invalidate(id); // 发生错误时移除缓存
        }
    }

//    /**
//     * 取消sse连接
//     * 要将redis，caffine里的缓存都删除
//     *
//     * @param Id
//     * @param driverEmittersKeys
//     */
//    public void unsubscribe(Long Id, String driverEmittersKeys) {
//
//    }
}
```

#### 由上面的具体应用可知:

Caffeine缓存用来充当SSE会话的管理池，存储sseEmitter实例，一个sseEmitter其实就对应着一个通信的通道连接着后端和前端,同时保证消息的单向推送(后端推送给前端)，为了保证集群情况下跨节点时指定的sseEmitter实例怎么找到的问题（就是比如说一个请求是要向id为1的司机推送消息，比如是附近有乘客下单，如果乘客下单成功的请求通过网关的负载均衡被端口为8081的节点接收到，而id为1的司机与后端的连接通道是在端口号为8082的节点上，那么8081的节点就要向8082的节点发送一条消息告诉8082节点利用自己本地缓存里连接id为1的司机与后端的sseEmitter实例来推送消息，这里就涉及到集群环境下跨节点通信的问题，我是用Redis分布式缓存存储每一个sseEmitter实例所在节点的端口，这样其它节点都可以知道，之后利用一个消息队列模型，每一个节点发送消息的方法都监听着一个队列，队列的名称里有统一的前缀和节点的端口号，路由键也是有统一的前缀和节点的端口号组成，这样的话就可以实现跨节点的消息推送），此外sseEmitter实例我设置的失效时间是一个小时，就是说一个小时之后sseEmitter用不了,同时也给SSE会话的管理池添加的sseEmitter的过期策略和移除策略

怎么获取每个节点的端口号：直接读取那个application配置文件肯定是不行的，因为写死了，所以我是通过**Spring Boot 事件监听机制**加延迟（给消息队列依赖的bean：交换机，绑定关系，队列和使用到消息队列的一些Bean类加@Lazy注解）加载消息队列相关Bean的方式来获取端口号，因为springboot启动时获取端口号如果太早了有些bean还没完全加载完就获取不到端口号，导致最后队列和路由键里有null，所以就通过Bean加载的方式先加载完获取端口号所需要的bean然后获取端口号，然后应用消息队列相关的Bean是懒加载，使用到的时候才会加载创建，这样就使得消息队列的路由键和队列名里都要端口号。