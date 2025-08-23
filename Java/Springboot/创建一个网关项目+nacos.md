## 创建一个网关项目

### 网关项目的依赖

**不需要导入springboot依赖**

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.0.2</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>   <!-- 注意版本对应 -->
<dependencies>
    <!--添加gateway网关-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-gateway</artifactId>
    </dependency>

    <!--nocos discovery-->
    <dependency>
        <groupId>com.alibaba.cloud</groupId>
        <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
    </dependency>

    <!--负载均衡-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-loadbalancer</artifactId>
    </dependency>
</dependencies>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>2022.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-alibaba-dependencies</artifactId>
            <version>2022.0.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<repositories>
    <repository>
        <id>spring-cloud-alibaba</id>
        <name>Spring Cloud Alibaba</name>
        <url>https://aliyun.oss-cn-hangzhou.aliyuncs.com/spring-cloud-alibaba/spring-cloud-alibaba-maven</url>
    </repository>
</repositories>
```

[版本说明 · alibaba/spring-cloud-alibaba Wiki](https://github.com/alibaba/spring-cloud-alibaba/wiki/版本说明)

### springboot、Cloud、CloudAlibaba版本说明里的一部分

| Spring Cloud Alibaba Version | Spring Cloud Version  | Spring Boot Version |
| ---------------------------- | --------------------- | ------------------- |
| 2022.0.0.0*                  | Spring Cloud 2022.0.0 | 3.0.2               |
| 2022.0.0.0-RC2               | Spring Cloud 2022.0.0 | 3.0.2               |
| 2022.0.0.0-RC1               | Spring Cloud 2022.0.0 | 3.0.0               |

### 配置yaml配置文件

```yaml
server:  
  port: 8082  # 设置 Spring Boot 应用的服务器端口为 8082  
spring:  
  application:  
    name: Gateway  # 设置 Spring Boot 应用的名称为 'Gateway'  
  cloud:  
    nacos:  
      server-addr: localhost:8848  # Nacos 服务发现的地址，通常用于服务注册与发现功能  
    gateway:  
      globalcors:  # 全局 CORS 配置  
        corsConfigurations:  
          '[/**]':  # 对所有路径都应用该 CORS 配置  
            allowedOrigins: "*"  # 允许来自任何源的请求  
            allowedMethods: "*"  # 允许所有 HTTP 方法（GET, POST, PUT, DELETE等）  
            allowedHeaders: "*"  # 允许所有请求头  
      routes:  # 路由配置  
        # 路由配置的列表，每个路由都包含一个标识、目标 URl、请求条件和过滤器  
        # 模拟订单处理的路由配置  
        - id: Simulated_order  # 路由的唯一标识  
          uri: lb://driverAndOrder-service # 目标服务的 URL  
          predicates:  
            - Path=/simulate/**  # 请求路径以 /simulate/ 开头的路由，将会匹配该设置  
          filters:  
            - StripPrefix=1  # 去掉请求路径中的前缀（即 /simulate/），使请求直接转发到 http://localhost:8081  
        # GeoServer 的路由配置  
        - id: geoserver  # 路由的唯一标识  
          uri: http://localhost:8080  # GeoServer 服务的目标 URL  
          predicates:  
            - Path=/geoserver/**  # 请求路径以 /geoserver/ 开头的路由，将会匹配该设置  
```

### 配置网关下每个微服务项目

```xml
    <!--导入依赖-->
   <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
  <!-- 配置maven仓库 -->
   <dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>2022.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-alibaba-dependencies</artifactId>
            <version>2022.0.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<repositories>
    <repository>
        <id>spring-cloud-alibaba</id>
        <name>Spring Cloud Alibaba</name>
        <url>https://aliyun.oss-cn-hangzhou.aliyuncs.com/spring-cloud-alibaba/spring-cloud-alibaba-maven</url>
    </repository>
</repositories>     
```

导入的依赖也要注意版本问题，具体版本对应见上面。

#### 之后就在网关下的每一个项目添加下面的配置

```yaml
server:
  port: 8081  # 修改为 8081
spring:
  cloud:
    discovery:
      enabled: true # 确保启用服务发现
    nacos:
      discovery:
        server-addr: localhost:8848 # nacos的地址
  application:
    name: Simulated_order
```

