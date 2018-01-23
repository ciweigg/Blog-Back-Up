title: swagger 注解使用
date: 2018-01-19 10:08:34
tags: [swagger]
categories: [swagger]
---
Swagger 是一个规范和完整的框架，用于生成、描述、调用和可视化 RESTful 风格的 Web 服务。Swagger的目标是对REST API定义一个标准的和语言无关的接口，可让人和计算机无需访问源码、文档或网络流量监测就可以发现和理解服务的能力。当通过Swagger进行正确定义，用户可以理解远程服务并使用最少实现逻辑与远程服务进行交互。与为底层编程所实现的接口类似，Swagger消除了调用服务时可能会有的猜测。
<!--more-->
关于Swagger的集成请参考：https://github.com/yinjihuan/spring-boot-starter-swagger

### API
@Api 用在类上，说明该类的作用。可以标记一个Controller类做为swagger 文档资源，使用方式如下：
```
@Api(value="企业用户控制器", tags={"用户接口"})
@RestController
@RequestMapping("/user")
public class EnterpriseProductUserController {

}
```
* value：接口说明
* tags：接口说明，可以在页面中显示。可以配置多个，当配置多个的时候，在页面中会显示多个接口的信息

### ApiModel
@ApiModel用在类上，表示对类进行说明，用于实体类中的参数接收说明，使用方式如下：
```
@ApiModel(value = "com.fangjia.fsh.user.query.LoginQuery", description = "登录参数")
public class LoginQuery {

}
```

### ApiModelProperty
@ApiModelProperty()用于字段,表示对model属性的说明,使用方式如下：
```
@ApiModel(value = "com.fangjia.fsh.user.query.LoginQuery", description = "登录参数")
public class LoginQuery {

    @ApiModelProperty(value = "企业编号", required = true)
    private Long eid;

    @ApiModelProperty(value = "用户编号", required = true)
    private String uid;

}
```

### ApiParam
@ ApiParam用于Controller中方法的参数说明，使用方式如下：
```
@PostMapping("/login")
public ResponseData login(@ApiParam(value = "登录参数", required = true) @RequestBody LoginQuery query) {

}
```
* value：参数说明
* required：是否必填

### ApiOperation
@ApiOperation用在Controller里的方法上，说明方法的作用，每一个接口的定义,使用方式如下：
```
@ApiOperation(value = "用户登录", notes = "企业用户认证接口，参数为必填项")
@PostMapping("/login")
public ResponseData login(@ApiParam(value = "登录参数", required = true) @RequestBody LoginQuery query) {

}
```
* value：接口名称
* notes：详细说明

### ApiResponse和ApiResponses
```
@ApiResponses({ @ApiResponse(code = 403, message = "无权限访问") })
public ResponseData login(@ApiParam(value = "登录参数", required = true) @RequestBody LoginQuery query) {

}
```
* code：响应状态码
* message：状态码对应的说明

### ApiImplicitParam和ApiImplicitParams
用于方法上，为单独的请求参数进行说明，使用方式如下：
```
@ApiImplicitParams({
      @ApiImplicitParam(name="uid", value="用户ID", required=true, paramType="query", dataType="String", defaultValue="1")
})
@GetMapping("/hello")
public String hello(String uid) {
   return uid;
}
```
* name：参数名，对应方法中单独的参数名称
* value：参数中文说明
* required：是否必填
* paramType：参数类型，取值为path, query, body, header, form
* dataType：参数数据类型
* defaultValue：默认值

