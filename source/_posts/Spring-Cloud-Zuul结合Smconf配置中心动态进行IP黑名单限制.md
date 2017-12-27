title: Spring Cloud Zuul结合Smconf配置中心动态进行IP黑名单限制
author: John Doe
tags:
  - SpringCloud
categories:
  - SpringCloud
date: 2017-12-22 13:40:00
---
API网关中最常见的一个功能就是防止爬虫，当然防止爬虫的前提是先得识别出这个请求是爬虫

这部分我们不涉及，假设我们已经能够识别出爬虫的请求了，那么怎么限制呢？

最常见的就是根据IP限制，某个IP大量访问就比较异常了

之前讲过 Spring Cloud 如何选择分布式配置中心 利用动态的配置中心我们可以最很多操作

这篇主要介绍下如何对IP进行禁用操作

<!-- more -->

首先是集成我们的配置中心Smconf, 至于怎么集成这边不做过多讲解，大家看下我们的github即可
https://github.com/yinjihuan/smconf

定义一个配置类用来存储IP黑名单信息

```
/**
 * 基础配置信息
 *
 * @author yinjihuan
 * @create 2017-11-15 17:06
 **/
@CxytianDiConf(system = "fangjia-fsh-api")
public class BasicConf {

    @ConfField("IP黑名单，多个用逗号分隔")
    private String ipStr = "default";

    public String getIpStr() {
        return ipStr;
    }

    public void setIpStr(String ipStr) {
        this.ipStr = ipStr;
    }
}
```
建一个Zuul的Filter,用来过滤黑名单中存在的IP, 这边直接可以在过滤器中使用配置信息

```
@Autowired
private BasicConf basicConf;

@Override
public Object run() {
    RequestContext ctx = RequestContext.getCurrentContext();
    String ip = IpUtils.getIpAddr(ctx.getRequest());
    // 在黑名单中禁用
    if (StringUtils.isNotBlank(ip) && basicConf != null && basicConf.getIpStr().contains(ip)) {
        ctx.set("isSuccess", false);
        ctx.setSendZuulResponse(false);
        ResponseData data = ResponseData.fail("非法请求", ResponseCode.NO_AUTH_CODE.getCode());
        ctx.setResponseBody(JsonUtils.toJson(data));
        ctx.getResponse().setContentType("application/json; charset=utf-8");
        return null;
    }
    return null;
}
```

在每个请求过来的时候都会去判断这个IP是否在黑名单中是否存在，如果存在则不进行转发操作，直接回复内容给客户端

我们假设判断是否为爬虫的程序已经好了，并且能够识别出爬虫的IP,识别出之后就将IP信息加入到配置中心即可，这边会实时更新配置中心的信息，来做限制

具体代码可以参考我的github:

https://github.com/yinjihuan/spring-cloud