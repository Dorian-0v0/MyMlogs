# MQ面经

## 怎么保证数据不丢失

1. #### **生产者发送消息确认机制**：

   生产者发送消息会收到mq的一个结果（ack或nack），告诉生产者发送成没成功（==就是有没有发送到交换机==），没成功就会多次重发（可以设置时间间隔和次数），再没成功就在生产者一方持久化消息然后**定时重发**，成功就删除生产者持久化的消息，处理nack时都会记录相关日志，此外还要确保发送的消息对于消费者来说是幂等的，因为重试的话可能会发送多条相同消息，幂等就是消费一次消息和多次消息的结果是一样。

2. #### **消息持久化**

   开启持久化功能可以确保mq里的消息不丢失,包括:

   - 交换机的持久化

     ```java
     @Bean
     public DirectExchange simpleExchange() {
         // 交换机的名称，是持久化，且没有自动删除
         return new DirectExchange("simple.direct", true, false);
     }
     ```

   - 队列的持久化

     ```java
     @Bean
     public Queue simpleQueue() {
         // 使用QueueBuilder构建队列， durable就是持久的
         return QueueBuilder.durable("simple.queue").build();
     }
     ```

   - 消息的持久化

     ```java
     Message msg = MessageBuilder
         .withBody(message.getBytes(StandardCharsets.UTF_8))
         .setDeliveryMode(MessageDeliveryMode.PERSISTENT) // 持久化
         .build();
     ```

3. #### 消费者确认

   消费者处理消息后可以向MQ发送ack结果，MQ收到ack回执后才会删除该消息。而SpringAMQP则允许配置三种确认模式：

   - manual：手动发送ack，需要在业务代码结束后，调用api发送ack；
   - auto：spring自动发送ack，由spring监测listener代码是否出现异常，没有异常则返回ack；抛出异常则返回nack；
   - none：不发送ack，消息投递后立即删除，不管处理消息有没有成功。

   也可以利用Spring的retry机制，在消费者出现异常时本地重试，设置重试次数，当次数达到以后，如果息依然失败，将消息投递到异常交换机，交由人工处理。

4. #### 重连机制

   由于网络原因，可能一下子连接不到MQ，所以就可以选择开启重连机制，一次连接不上就等一下再连接，取保连接上收到ack，但是要注意等待重试的时间是阻塞的，会影响业务的性能，导致响应时间过长，

## 消息的重复消费怎么解决

- 每条消息设置一个唯一id，消费者去判断有没有消费某个id的消息。
- 幂等方案：重复接收同一个消息但最终结果和直接收一个消息的结果一样，加乐观锁，分布式锁
