title: Spring Cloud Eureka 控制台快速查看Swagger API文档
date: 2017-12-22 13:35:00
tags: [swagger]
categories: [SpringCloud,swagger]
---
在服务比较多的情况下，突然想看某个服务的API 文档

虽然外面使用了Swagger来进行API的管理，但是还是得找到对应的服务，然后访问Swagger的管理页面才行。

为了方便查询文档，把这个功能集成到Eureka中，这样就很方便了

<!-- more -->

默认的Instances也是有链接跳转的，外面需要把这个跳转改成Swagger的管理页面

这样直接点击 **fsh-house:192.168.10.170:2101** 就能跳转到Swagger

![paste image](http://oisa91ton.bkt.clouddn.com/1513921058272fqw8kbq3.png?imageslim)

很简单，只需要加上下面的配置即可：

```
eureka.instance.status-page-url=http://${spring.cloud.client.ipAddress}:${server.port}/swagger-ui.html
```