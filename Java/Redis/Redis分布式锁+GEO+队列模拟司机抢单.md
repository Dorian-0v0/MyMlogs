## Redis模拟滴滴司机抢单项目文档
---
### 数据库设计结构

#### 订单表
- **订单ID**
- **客户ID**
- **订单状态**
- **订单起点坐标**
- **订单终点坐标**
- **订单距离**
- **抢到单的司机ID**
- **车牌号**
- **抢单时间**
- **完成订单的时间**
- **发出订单的时间**

#### 司机表
- **司机ID**
- **可接受客户的距离**
- **可接收的订单距离**
- **司机状态**
- **车牌号**

#### 乘客表
- **ID**
- **Name**
- **查找多大范围内的司机**
---
### Redis三个key
1. **抢单的司机id+司机位置**
2. **订单id+起始位置**  
   - **类型**：排序集合  
   - **排序依据**：按照距离排序  
   - **存储内容**：订单ID
---
### 流程
#### 乘客下单
1. 乘客发起订单请求。
2. 将订单ID和乘客的地理位置存入Redis（创建一个订单key，设置过期时间为15分钟）。
3. 给附件五公里且开启接单的司机发生一条消息
#### 司机搜索订单
1. 司机启动订单搜索功能（开启SSE通道）。
2. 在Redis的订单key中**按半径**搜索符合以下条件的订单：
   - 订单起点与司机当前位置的距离在司机可接受的范围内。
   - 订单的距离在司机可接单范围内
3. 将符合条件的订单ID存入以司机ID命名的Redis集合中（例如：`driver:<driver_id>`），并按照距离进行排序zset。
4. 返回的一个VO：

#### 司机抢单
```
// 2.加分布式锁锁单，防止别的线程抢单
//       2.1：修改订单状态、抢到单的司机ID、抢单时间
// 3：修改成功就移除redis里的订单
// 4：修改司机状态为不可接单
// 5.推送消息给乘客和司机
```

1. 司机选择点击“抢单”按钮。
2. 对订单进行分布式锁操作（锁的key为订单ID，确保同一时间只有一个司机可以操作该订单）。
3. 如果抢单成功：
   - 更新订单状态为“已接单”。
   - 更新订单的“抢到单的司机ID”字段为当前司机的ID。
   - 更新抢单时间为当前时间。
   - 将订单id和位置从redis里删除
   - 告诉乘客和司机
4. 如果抢单失败：
   - 清空司机Redis集合中当前的订单ID。
   - 再次搜索满足条件的订单ID。

#### 乘客取消订单
1. 乘客发起取消订单请求。
2. 对订单进行分布式锁操作（锁的key为订单ID）。
3. 更新订单状态为“已取消”。
4. 清空与该订单相关的Redis数据（如司机集合中的订单ID等）。
5. 发生信息给司机和乘客

#### 司机取消订单

1. 更新订单状态为“未接单”。
2. 更新订单的“抢到单的司机ID”字段为null。
3. 更新抢单时间为当前时间。
4. 将订单id和位置重新加入订单redis
5. 告诉乘客

#### 司机完成订单

1. 判断司机位置是否在目的地附近300米，不在返回失败
2. 如果在，那发生支付信息给用户（判断有没有支付）

#### 用户下单

1. 支付
2. 修改订单状态
3. 通知司机
4. 订单存入Mongodb

## Redisson锁解决的问题
- 给分布式系统加锁，解决了Synchronized 只能加到单个jvm里的线程。
- 解决锁的误删除，取保加锁和释放锁的操作只能由一个线程完成
- 解决了锁的原子性问题：在高并发的情况下判断锁有没有被持有不会出现多个线程都判断没有持有从而都获取锁。

插入坐标：
**INSERT INTO points (name, geom)
VALUES ('Point1', ST_MakePoint(120.12345, 30.67890));**

## 分布式系统的全局唯一id

### 为什么不使用数据库自增长id策略

- id的规律明显，会被猜测到
- 当数据量特别多的时候单表拆分id又会从1开始

### 基于时间戳+Redis生成全局唯一id的方案

![img](https://i-blog.csdnimg.cn/direct/d805e05d3c6245d599d8510f30fef975.png)

![img](https://i-blog.csdnimg.cn/direct/3f7939d35fd343978424406c09d3cc77.png)

**生成唯一自增id的代码**

```java
@Component
public class RedisIdWorker {
    /**  
     * 开始时间戳,该文件生成的时间大概吧2025年4月  
     */  
    private static final long BEGIN_TIMESTAMP = 1745056748L; //
    private static final long COUNT_BITS = 32L; // 位移32位
 
    @Autowired
    private RedisTemplate redisTemplate;
 
    // 生成订单Id   long为64位
    public Long nextId(String keyPrefix) {
        // 1.生成时间戳
        LocalDateTime now = LocalDateTime.now();
        long nowSecond = now.toEpochSecond(ZoneOffset.UTC);
        long timestamp = nowSecond - BEGIN_TIMESTAMP; // 某一秒对应的时间戳

        //获取当前日期，精准到天
        String date = now.format(DateTimeFormatter.ofPattern("yyyy:MM:dd"));
        //自增长，初始值为0，就算生成空指针也会转为一个随机数，
        // key的值为：order:id:当前日期
        long count = redisTemplate.opsForValue().increment(keyPrefix + ":id:" + date);
        // 3.拼接并返回  |运算相当于对应位置上不为0处最后算为1
        return timestamp << COUNT_BITS | count;
    }
}
```

# springboot整合Redis

#### 导入依赖

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

#### 配置yml文件

```yml
data:
    redis:
      host: localhost
      port: 6379
```

之后直接使用
