title: Spring Boot中使用Flyway来初始化数据库并控制版本
date: 2018-01-04T05:19:06.885Z
tags: [SpringBoot,Flyway]
categories: [SpringBoot]
---
### Flyway简介
Flyway是一个简单开源数据库版本控制器（约定大于配置），主要提供migrate、clean、info、validate、baseline、repair等命令。它支持SQL（PL/SQL、T-SQL）方式和Java方式，支持命令行客户端等，还提供一系列的插件支持（Maven、Gradle、SBT、ANT等）。
官方网站：https://flywaydb.org/
在Spring Boot应用中的应用，如何使用Flyway来创建数据库以及结构不一致的检查。
主要用于初始化数据库，数据库必须先创建好，里面不能有表
<!--more-->
1. 第一步，在pom.xml中增加flyway的依赖
：
```
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
    <version>5.0.3</version>
</dependency>
```
2. 第二步，按Flyway的规范创建版本化的SQL脚本
在工程的src/main/resources目录下创建db目录
在db目录下创建版本化的SQL脚本V1__Base_version.sql(脚本名字不能随便乱起)
```
DROP TABLE IF EXISTS user ;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(20) NOT NULL COMMENT '姓名',
  `age` int(5) DEFAULT NULL COMMENT '年龄',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```
3. 第三步，在application.properties文件中配置Flyway要加载的SQL脚本位置。按第二步创建的结果配置如下
```
flyway.locations=classpath:/db
```
4. 第四步，执行单元测试ApplicationTests，此时我们在日志中可以看到如下信息
```
INFO 82441 --- [main] o.f.core.internal.util.VersionPrinter    : Flyway Community Edition 5.0.3 by Boxfuse
INFO 82441 --- [main] o.f.c.internal.database.DatabaseFactory  : Database: jdbc:mysql://localhost:3306/test (MySQL 5.7)
INFO 82441 --- [main] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.022s)
INFO 82441 --- [main] o.f.c.i.s.JdbcTableSchemaHistory         : Creating Schema History table: `test`.`flyway_schema_history`
INFO 82441 --- [main] o.f.core.internal.command.DbMigrate      : Current version of schema `test`: << Empty Schema >>
INFO 82441 --- [main] o.f.core.internal.command.DbMigrate      : Migrating schema `test` to version 1 - Base version
WARN 82441 --- [main] o.f.core.internal.sqlscript.SqlScript    : DB: Unknown table 'test.user' (SQL State: 42S02 - Error Code: 1051)
INFO 82441 --- [main] o.f.core.internal.command.DbMigrate      : Successfully applied 1 migration to schema `test` (execution time 00:00.128s)
```
Flyway监测到需要运行版本脚本来初始化数据库，因此执行了V1__Base_version.sql脚本，从而创建了user表，这才得以让一系列单元测试（对user表的CRUD操作）通过。
5. 第五步，我们可以继续再执行一下单元测试，此时我们会发现日志输出与之前不同
```
INFO 83150 --- [main] o.f.core.internal.util.VersionPrinter    : Flyway Community Edition 5.0.3 by Boxfuse
INFO 83150 --- [main] o.f.c.internal.database.DatabaseFactory  : Database: jdbc:mysql://localhost:3306/test (MySQL 5.7)
INFO 83150 --- [main] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.031s)
INFO 83150 --- [main] o.f.core.internal.command.DbMigrate      : Current version of schema `test`: 1
INFO 83150 --- [main] o.f.core.internal.command.DbMigrate      : Schema `test` is up to date. No migration necessary.
```
由于在第四步的时候，初始化脚本已经执行过，所以这次执行就没有再去执行V1__Base_version.sql脚本来重建user表。
6. 第六步，我们可以尝试修改一下V1__Base_version.sql脚本中的name字段长度，然后在运行一下单元测试，此时我们可以得到如下错误
```
ERROR 83791 --- [main] o.s.boot.SpringApplication               : Application startup failed

org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'flywayInitializer' defined in class path resource [org/springframework/boot/autoconfigure/flyway/FlywayAutoConfiguration$FlywayConfiguration.class]: Invocation of init method failed; nested exception is org.flywaydb.core.api.FlywayException: Validate failed: Migration checksum mismatch for migration version 1
-> Applied to database : 466264992
-> Resolved locally    : -270269434
```
由于初始化脚本的改动，Flyway校验失败，认为当前的V1__Base_version.sql脚本与上一次执行的内容不同，提示报错并终止程序，以免造成更严重的数据结构破坏。