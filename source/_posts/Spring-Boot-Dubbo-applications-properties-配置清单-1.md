title: Spring Boot Dubbo applications.properties 配置清单
author: John Doe
tags:
  - SpringBoot
categories:
  - SpringBoot
date: 2017-12-10 18:02:00
---
Springboot 整合 Dubbo/ZooKeeper 详解 SOA 案例

Spring Boot 中如何使用 Dubbo Activate 扩展点
<!-- more -->
Q：如果一个程序既提供服务又是消费者怎么配置 scan package？
A（群友周波）： 就是 com.xxx.provider 生产者，com.xxx.consumer 消费者，那么 scan package 就设置到 com.xxx

Q：如何设置消费者调用生产者的超时时间？
A：目前不能通过 application.properties 定义。@Reference timeout

Q：consumer 怎么配置接入多个 provider？
A：@Reference 可以指定不同的 register。register （注册中心 like provider container）里面可以对应多个 provider

Q： @Service(version = “1.0.0”) 这个 1.0.0 可以从 application.properties 配置文件中读取吗？可以区分不同的环境，可以统一升级管理
A：占时还没有解决… 但是应用环境，如：dev/test/run 可以使用下面的配置，在 application.properties 定义
spring.dubbo.application.environment

Spring Boot 整合 Dubbo 的项目依赖了 spring-boot-starter-dubbo 工程，该项目地址是 https://github.com/teaey/spring-boot-starter-dubbo。 感谢作者~

二、applications.properties 配置清单
根据 starter 工程源码，可以看出 application.properties 对应的 Dubbo 配置类 DubboProperties 。

@ConfigurationProperties(prefix = "spring.dubbo")
public class DubboProperties {

    private String scan;

    private ApplicationConfig application;

    private RegistryConfig registry;

    private ProtocolConfig protocol;
}
包括了扫描路径、应用配置类、注册中心配置类和服务协议类

所以具体常用配置下
扫描包路径：指的是 Dubbo 服务注解的服务包路径

# Dubbo 配置
## 扫描包路径
spring.dubbo.scan=org.spring.springboot.dubbo
应用配置类：关于 Dubbo 应用级别的配置

这里注意多个注册中心的配置方式。下面介绍单个注册中心的配置方式。

# Dubbo 应用配置
## 应用名称
spring.dubbo.application.name=xxx

## 模块版本
spring.dubbo.application.version=xxx

## 应用负责人
spring.dubbo.application.owner=xxx

## 组织名(BU或部门)
spring.dubbo.application.organization=xxx

## 分层
spring.dubbo.application.architecture=xxx

## 环境，如：dev/test/run
spring.dubbo.application.environment=xxx

## Java代码编译器
spring.dubbo.application.compiler=xxx

## 日志输出方式
spring.dubbo.application.logger=xxx

## 注册中心 0
spring.dubbo.application.registries[0].address=zookeeper:#127.0.0.1:2181=xxx
## 注册中心 1
spring.dubbo.application.registries[1].address=zookeeper:#127.0.0.1:2181=xxx

## 服务监控
spring.dubbo.application.monitor.address=xxx
注册中心配置类：常用 ZooKeeper 作为注册中心进行服务注册。

# Dubbo 注册中心配置类
## 注册中心地址
spring.dubbo.application.registries.address=xxx

## 注册中心登录用户名
spring.dubbo.application.registries.username=xxx

## 注册中心登录密码
spring.dubbo.application.registries.password=xxx

## 注册中心缺省端口
spring.dubbo.application.registries.port=xxx

## 注册中心协议
spring.dubbo.application.registries.protocol=xxx

## 客户端实现
spring.dubbo.application.registries.transporter=xxx

spring.dubbo.application.registries.server=xxx

spring.dubbo.application.registries.client=xxx

spring.dubbo.application.registries.cluster=xxx

spring.dubbo.application.registries.group=xxx

spring.dubbo.application.registries.version=xxx

## 注册中心请求超时时间(毫秒)
spring.dubbo.application.registries.timeout=xxx

## 注册中心会话超时时间(毫秒)
spring.dubbo.application.registries.session=xxx

## 动态注册中心列表存储文件
spring.dubbo.application.registries.file=xxx

## 停止时等候完成通知时间
spring.dubbo.application.registries.wait=xxx

## 启动时检查注册中心是否存在
spring.dubbo.application.registries.check=xxx

## 在该注册中心上注册是动态的还是静态的服务
spring.dubbo.application.registries.dynamic=xxx

## 在该注册中心上服务是否暴露
spring.dubbo.application.registries.register=xxx

## 在该注册中心上服务是否引用
spring.dubbo.application.registries.subscribe=xxx
服务协议配置类：

# Dubbo 服务协议配置

## 服务协议
spring.dubbo.application.protocol.name=xxx

## 服务IP地址(多网卡时使用)
spring.dubbo.application.protocol.host=xxx

## 服务端口
spring.dubbo.application.protocol.port=xxx

## 上下文路径
spring.dubbo.application.protocol.contextpath=xxx

## 线程池类型
spring.dubbo.application.protocol.threadpool=xxx

## 线程池大小(固定大小)
spring.dubbo.application.protocol.threads=xxx

## IO线程池大小(固定大小)
spring.dubbo.application.protocol.iothreads=xxx

## 线程池队列大小
spring.dubbo.application.protocol.queues=xxx

## 最大接收连接数
spring.dubbo.application.protocol.accepts=xxx

## 协议编码
spring.dubbo.application.protocol.codec=xxx

## 序列化方式
spring.dubbo.application.protocol.serialization=xxx

## 字符集
spring.dubbo.application.protocol.charset=xxx

## 最大请求数据长度
spring.dubbo.application.protocol.payload=xxx

## 缓存区大小
spring.dubbo.application.protocol.buffer=xxx

## 心跳间隔
spring.dubbo.application.protocol.heartbeat=xxx

## 访问日志
spring.dubbo.application.protocol.accesslog=xxx

## 网络传输方式
spring.dubbo.application.protocol.transporter=xxx

## 信息交换方式
spring.dubbo.application.protocol.exchanger=xxx

## 信息线程模型派发方式
spring.dubbo.application.protocol.dispatcher=xxx

## 对称网络组网方式
spring.dubbo.application.protocol.networker=xxx

## 服务器端实现
spring.dubbo.application.protocol.server=xxx

## 客户端实现
spring.dubbo.application.protocol.client=xxx

## 支持的telnet命令，多个命令用逗号分隔
spring.dubbo.application.protocol.telnet=xxx

## 命令行提示符
spring.dubbo.application.protocol.prompt=xxx

## status检查
spring.dubbo.application.protocol.status=xxx

## 是否注册
spring.dubbo.application.protocol.status=xxx
三、@Service 服务提供者常用配置
常用 @Service 配置的如下

version 版本
group 分组
provider 提供者
protocol 服务协议
monitor 服务监控
registry 服务注册
…
四、@Reference 服务消费者常用配置
常用 @Reference 配置的如下

version 版本
group 分组
timeout 消费者调用提供者的超时时间
consumer 服务消费者
monitor 服务监控
registry 服务注册