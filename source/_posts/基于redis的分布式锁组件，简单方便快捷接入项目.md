title: 基于redis的分布式锁组件，简单方便快捷接入项目
date: 2018-01-08 11:01:00
tags: [分布式锁]
categories: [分布式锁]
---
使项目拥有分布式锁能力 https://github.com/kekingcn/spring-boot-klock-starter
spring-boot-klock-starter
基于redis的分布式锁spring-boot starter组件，使得项目拥有分布式锁能力变得异常简单，支持spring boot，和spirng mvc等spring相关项目
<!--more-->
快速开始
spring boot项目接入

1.添加lock starter组件依赖，目前还没上传到公共仓库，需要自己下源码build
```
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-klock-starter</artifactId>
        <version>1.0-SNAPSHOT</version>
    </dependency>
```

2.application.properties配置redis链接：
```
spring.klock.address=127.0.0.1:6379
```

3.在需要加分布式锁的方法上，添加注解@Klock，如：
```
@Service
public class TestService {

    @Klock(waitTime = Long.MAX_VALUE)
    public String getValue(String param) throws Exception {
        if ("sleep".equals(param)) {//线程休眠或者断点阻塞，达到一直占用锁的测试效果
            Thread.sleep(1000 * 50);
        }
        return "success";
    }
}
```