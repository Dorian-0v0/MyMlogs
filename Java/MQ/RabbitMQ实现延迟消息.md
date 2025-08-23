

## 延迟消息介绍

延迟消息：**发送者发送消息时指定一个时间，消费者不会立即收到消息，而是在指定时间之后才收到消息。**

## 基于插件的方式实现延迟消息

![image-20250502175146563](assets/image-20250502175146563.png)

下载延迟队列插件的地址：[Releases · rabbitmq/rabbitmq-delayed-message-exchange](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases)

1. 找到 `rabbitmq_delayed_message_exchange` 插件，下载与你的 RabbitMQ 版本兼容的 `.ez` 文件
2. 默认插件目录通常位于：`C:\Program Files\RabbitMQ Server\rabbitmq_server-版本号\plugins`将下载的 `.ez` 文件复制到此目录
3. 打开命令提示符（以管理员身份运行）
4. 导航到 RabbitMQ 的 sbin 目录：

```
cd "C:\Program Files\RabbitMQ Server\rabbitmq_server-版本号\sbin"
```

5. 执行以下命令启用插件：

```
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

6. **重启 RabbitMQ 服务**，通过service重启rabbitmq。
7. 打开http://localhost:15672网址进行校验，登录后，在 "Exchanges" 标签页中创建新交换器时，应该能看到 "x-delayed-message" 类型选项

```java
@Configuration
public class RabbitMQTopicConfig {

    public static final String DELAY_EXCHANGE_NAME = "trade.delay.direct";

    public static final String DELAY_ORDER_QUEUE_NAME = "trade.delay.order.queue";

    public static final String DELAY_ORDER_KEY = "delay.order.query";
    
     // 声明延时队列
    @Bean
    public Queue delayOrderQueue() {
        return QueueBuilder.durable(DELAY_ORDER_QUEUE_NAME).build();
    }
    
    // 声明延时交换机（自定义类型为x-delayed-message）
    @Bean
    public CustomExchange delayExchange() {
        Map<String, Object> args = new HashMap<>();
        args.put("x-delayed-type", "direct");
        return new CustomExchange(DELAY_EXCHANGE_NAME, "x-delayed-message", true, false, args);
    }

    // 绑定队列到交换机
    @Bean
    public Binding delayBinding(Queue delayOrderQueue, CustomExchange delayExchange) {
        return BindingBuilder.bind(delayOrderQueue)
                .to(delayExchange)
                .with(DELAY_ORDER_KEY)
                .noargs();
    }
}    
```

**发送延时消息**

```java
public void sendDelayMessage(Long orderId, long delayTime) {
        // 发送延时消息
        rabbitTemplate.convertAndSend(
                RabbitMQTopicConfig.DELAY_EXCHANGE_NAME,
                RabbitMQTopicConfig.DELAY_ORDER_KEY,
                orderId,
                new MessagePostProcessor() {
                    @Override
                    public Message postProcessMessage(Message message) throws AmqpException {
                        // 设置延时时间（毫秒）
                        message.getMessageProperties().setHeader("x-delay", delayTime);
                        return message;
                    }
                });
    }
```

**接收延时消息**

```java
@RabbitListener(queues = RabbitMQTopicConfig.DELAY_ORDER_QUEUE_NAME)
    public void processDelayMessage(Long orderId) {
        log.info("收到延迟消息，订单ID: {}", orderId);
        // 查询订单信息
        Order order = orderMapper.selectById(orderId);
        if(order.getStatus().equals(4)){ // 已经完成订单
            return;
        }
        if(order.getStatus().equals(2)){
            MqRequest mqRequest = new MqRequest();
            mqRequest.setId(orderId);
            mqRequest.setType((byte) 1);
            mqRequest.setMessage("订单已超时未接单，请重新下单");
            sendSse(mqRequest);
        }
    }
```



