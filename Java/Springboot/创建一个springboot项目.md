## 创建一个springboot项目

### 导入必须的依赖

- Lombok
- Spring Web
- MyBatis Framework
- MySQL Driver
- Redis

如果是使用mybatisplus，则导入（也要注意版本的匹配）
```xml
 <dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-spring-boot3-starter</artifactId>
    <version>3.5.7</version>
</dependency>
```
hutool工具包
```xml
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.8.11</version>
</dependency>
```

### yaml配置文件里修改端口号

```yaml
server:
  port: 8081  # 修改为 8081
```

### 解决跨域问题跨域

**跨域发生在前端**

#### 后端设置响应头允许跨域。

```java

@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowedHeaders("*");
    }
}
```

#### 前端请求同域代理服务器(比如nginx)，由代理转发请求到目标服务器。

```javascript
import axios from 'axios';  
 
const baseURL = '/api';  
const instance = axios.create({ baseURL });  
......
```

```java
// 导出一个默认的对象，该对象定义了Vite的配置
export default defineConfig({
 ......
  // server对象用于配置开发服务器选项
  server: {
    // proxy属性用于配置代理规则
    proxy: {
      // 定义'/api'路径的代理规则
      '/api': {
        target: 'http://localhost:8080',// target属性指定代理目标服务器的地址
        changeOrigin: true, // changeOrigin属性设置为true，表示在代理请求时修改请求头中的Origin字段
        rewrite: (path) => path.replace(/^\/api/, '') // rewrite属性用于重写请求路径
        // 这里的重写规则是将请求路径中的'/api'前缀去掉，例如请求'/api/user'会被重写为'/user'
      }
    }
  }
})
```
