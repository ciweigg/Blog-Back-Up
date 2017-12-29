title: 【springboot】 springboot 整合mybatis-plus
author: John Doe
tags:
  - SpringBoot
  - Mybatis
categories:
  - SpringBoot
  - Mybatis
date: 2017-12-23 10:05:00
---
(转)springboot整和mybatis-plus

整合步骤,以后开发可以使用mybatis-plus了功能非常强大

文档地址：http://baomidou.oschina.io/mybatis-plus-doc

<!-- more -->

# 1.pom.xml 添加mp依赖

```
<!-- mybatis-plus begin -->
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
<dependency>
	<groupId>com.baomidou</groupId>
	    <artifactId>mybatisplus-spring-boot-starter</artifactId>
	<version>${mybatisplus-spring-boot-starter.version}</version>
</dependency>
<dependency>
	<groupId>com.baomidou</groupId>
	<artifactId>mybatis-plus</artifactId>
	<version>${mybatisplus.version}</version>
</dependency>
<!-- 如果要使用mp的代码生成还需要加入模板引擎,不建议使用maven插件生成啦！！！ -->
<dependency>
	<groupId>org.apache.velocity</groupId>
	<artifactId>velocity</artifactId>
	<version>${velocity.version}</version>
</dependency>
<!-- mybatis-plus end -->
```

# 2.application.yml 配置

```
# datasoure默认使用JDBC
spring:
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    username: root
    password: root
    url: jdbc:mysql://127.0.0.1/cloud?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true

#mybaits-plus配置，修改主键类型，mapper.xml、type 别名等
mybatis-plus:
  mapper-locations: classpath:/mapper/*Mapper.xml
  typeAliasesPackage: com.example.sbmp.entity
  global-config:
    #主键类型  0:"数据库ID自增", 1:"用户输入ID",2:"全局唯一ID (数字类型唯一ID)", 3:"全局唯一ID UUID";
    id-type: 0
    #字段策略 0:"忽略判断",1:"非 NULL 判断"),2:"非空判断"
    field-strategy: 0
    #驼峰下划线转换
    db-column-underline: true
    #刷新mapper 调试神器
    refresh-mapper: true
    #数据库大写下划线转换
    #capital-mode: true
  configuration:
    map-underscore-to-camel-case: true
    cache-enabled: true
```

# 3.mapper扫描配置

```
@Configuration
@MapperScan("com.example.sbmp.mapper*")
public class MybatisPlusConfig {
    @Bean
    public PaginationInterceptor paginationInterceptor() {
        return new PaginationInterceptor();
    }
}
```

# 4.代码生成配置,来源官方文档（Main方法，maven插件不兼容2.0+版本啦，不推荐使用啦）

```
public class MybatisPlusGenerator {
    public static void main(String[] args) {
        AutoGenerator mpg = new AutoGenerator();

        // 全局配置
        GlobalConfig gc = new GlobalConfig();
        gc.setOutputDir("D://data");
        gc.setFileOverride(true);
        gc.setActiveRecord(true);
        gc.setEnableCache(false);// XML 二级缓存
        gc.setBaseResultMap(true);// XML ResultMap
        gc.setBaseColumnList(false);// XML columList
        gc.setAuthor("lengleng");
        mpg.setGlobalConfig(gc);

        // 数据源配置
        DataSourceConfig dsc = new DataSourceConfig();
        dsc.setDbType(DbType.MYSQL);
        dsc.setDriverName("com.mysql.jdbc.Driver");
        dsc.setUsername("root");
        dsc.setPassword("root");
        dsc.setUrl("jdbc:mysql://127.0.0.1:3306/cloud?characterEncoding=utf8");
        mpg.setDataSource(dsc);

        // 策略配置
        StrategyConfig strategy = new StrategyConfig();
        // strategy.setCapitalMode(true);// 全局大写命名 ORACLE 注意
        strategy.setTablePrefix(new String[]{"tlog_", "tsys_"});// 此处可以修改为您的表前缀
        strategy.setNaming(NamingStrategy.underline_to_camel);// 表名生成策略
        mpg.setStrategy(strategy);

        // 包配置
        PackageConfig pc = new PackageConfig();
        pc.setParent("com.example.sbmp");
        mpg.setPackageInfo(pc);

        mpg.execute();
    }
}
```

5.把生成的代码扔到源码下，开始springboot和mybatis 的使用吧。

一些常用功能的说明
配置二级缓存
application.yml 配置的cache-enabled: true 并不是开启SQL的缓存，而是开启动态加载 mapper.xml

配置方式通普通方式一样在mapper.xml 配置 （注意在生成时候可以设置）
```
<cache/>
```
关于一级缓存和二级缓存

一级缓存属于sqlSession级别的，同一个sqlSession调用会被命中
二级缓存属于mapper级别的，同一个mapper调用会被命中

配置logback.xml 显示mybatis执行SQL
#在application.yml配置
```
logging:
  config: classpath:logback.xml
 #1.在logback.xml 配置一个logger节点，指定mapper包下日志级别DEBU，并执行一个console appender。（这种方式不受ROOT级别的控制）
<logger name="com.example.sbmp.mapper" level="DEBUG">
    <appender-ref ref="STDOUT"/>
</logger>
```
源码： http://git.oschina.net/boding1/pig-cloud/tree/master/springboot-mybatis-plus