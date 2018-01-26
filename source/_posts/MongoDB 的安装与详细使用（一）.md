title: MongoDB 的安装与详细使用（一）
tags:
  - MongoDB
categories:
  - MongoDB
date: 2018-01-26 13:35:06
---
# 一、什么是MongoDB ?

MongoDB 是由C++语言编写的，是一个基于分布式文件存储的开源数据库系统。

在高负载的情况下，添加更多的节点，可以保证服务器性能。

MongoDB 旨在为WEB应用提供可扩展的高性能数据存储解决方案。

MongoDB 将数据存储为一个文档，数据结构由键值(key=>value)对组成。

MongoDB 文档类似于 JSON 对象。字段值可以包含其他文档，数组及文档数组。
<!--more-->
![paste image](http://oisa91ton.bkt.clouddn.com/151694512210854qcloas.png?imageslim)

# 二、MongoDB 优缺点

**优点**

- 文档结构的存储方式，能够更便捷的获取数据
- 内置GridFS，支持大容量的存储
- 海量数据下，性能优越
- 动态查询
- 全索引支持,扩展到内部对象和内嵌数组
- 查询记录分析
- 快速,就地更新
- 高效存储二进制大对象 (比如照片和视频)
- 复制（复制集）和支持自动故障恢复
- 内置 Auto- Sharding 自动分片支持云级扩展性，分片简单
- MapReduce 支持复杂聚合
- 商业支持,培训和咨询


**缺点**

- 不支持事务操作
- MongoDB 占用空间过大 （不过这个确定对于目前快速下跌的硬盘价格来说，也不算什么缺点了）
- MongoDB没有如MySQL那样成熟的维护工具
- 无法进行关联表查询，不适用于关系多的数据
- 复杂聚合操作通过mapreduce创建，速度慢
- 模式自由,自由灵活的文件存储格式带来的数据错
- MongoDB 在你删除记录后不会在文件系统回收空间。除非你删掉数据库。但是空间没有被浪费

# 三、优缺点详细解释

**1.内置GridFS，支持大容量的存储：**

GridFS是一个出色的分布式文件系统，可以支持海量的数据存储。
内置了GridFS了MongoDB，能够满足对大数据集的快速范围查询。

**2.内置 Auto- Sharding 自动分片支持云级扩展性，分片简单**

提供基于Range的Auto Sharding机制：

一个collection可按照记录的范围，分成若干个段，切分到不同的Shard上。

Shards可以和复制结合，配合Replica sets能够实现Sharding+fail-over，不同的Shard之间可以负载均衡。  
查询是对客户端是透明的。客户端执行查询，统计，MapReduce等操作，这些会被MongoDB自动路由到后端的数据节点。  
这让我们关注于自己的业务，适当的 时候可以无痛的升级。MongoDB的Sharding设计能力最大可支持约20 petabytes，足以支撑一般应用。  
这可以保证MongoDB运行在便宜的PC服务器集群上。PC集群扩充起来非常方便并且成本很低，避免了“sharding”操作的复杂性和成本。  
 
**3.海量数据下，性能优越：**

在使用场合下，千万级别的文档对象，近10G的数据，对有索引的ID的查询不会比mysql慢，而对非索引字段的查询，则是全面胜出。 mysql实际无法胜任大数据量下任意字段的查询，而mongodb的查询性能实在让我惊讶。写入性能同样很令人满意，同样写入百万级别的数 据，mongodb比我以前试用过的couchdb要快得多，基本10分钟以下可以解决。补上一句，观察过程中mongodb都远算不上是CPU杀手。

**4.全索引支持,扩展到内部对象和内嵌数组**

索引通常能够极大的提高查询的效率，如果没有索引，MongoDB在读取数据时必须扫描集合中的每个文件并选取那些符合查询条件的记录。

这种扫描全集合的查询效率是非常低的，特别在处理大量的数据时，查询可以要花费几十秒甚至几分钟，这对网站的性能是非常致命的。

索引是特殊的数据结构，索引存储在一个易于遍历读取的数据集合中，索引是对数据库表中一列或多列的值进行排序的一种结构。

**5.MapReduce 支持复杂聚合**

MongoDB中聚合(aggregate)主要用于处理数据(诸如统计平均值,求和等)，并返回计算后的数据结果。有点类似sql语句中的 count(*)。


**与关系型数据库相比，MongoDB的缺点：**

**mongodb不支持事务操作：**

所以事务要求严格的系统（如果银行系统）肯定不能用它。

**mongodb不支持事务操作：**

所以事务要求严格的系统（如果银行系统）肯定不能用它。

**mongodb占用空间过大：**

关于其原因，在官方的FAQ中，提到有如下几个方面：

1、空间的预分配：为避免形成过多的硬盘碎片，mongodb每次空间不足时都会申请生成一大块的硬盘空间，而且申请的量从64M、128M、256M那 样的指数递增，直到2G为单个文件的最大体积。随着数据量的增加，你可以在其数据目录里看到这些整块生成容量不断递增的文件。

2、字段名所占用的空间：为了保持每个记录内的结构信息用于查询，mongodb需要把每个字段的key-value都以BSON的形式存储，如果 value域相对于key域并不大，比如存放数值型的数据，则数据的overhead是最大的。一种减少空间占用的方法是把字段名尽量取短一些，这样占用 空间就小了，但这就要求在易读性与空间占用上作为权衡了。

3、删除记录不释放空间：这很容易理解，为避免记录删除后的数据的大规模挪动，原记录空间不删除，只标记“已删除”即可，以后还可以重复利用。

4、可以定期运行db.repairDatabase()来整理记录，但这个过程会比较缓慢

MongoDB没有如MySQL那样成熟的维护工具，这对于开发和IT运营都是个值得注意的地方。

# 四、安装与使用

MongoDB 3.6不支持Ubuntu 12.04

本文使用：Ubuntu 16.04 x64

安装MongoDB的企业版

## 1. 导入公钥

导入包管理系统使用的公钥。

Ubuntu软件包管理工具（即dpkg和apt）通过要求分发者使用GPG密钥签署软件包来确保软件包的一致性和真实性，使用以下命令导入。

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
```

## 2. 创建列表文件

```sh
echo "deb [ arch=amd64,arm64,ppc64el,s390x ] http://repo.mongodb.com/apt/ubuntu xenial/mongodb-enterprise/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list
```

## 3. 更新仓库

```sh
echo apt-get update
```
## 4. 安装服务

**安装MongoDB Enterprise软件包**

安装MongoDB企业版本3.6

```sh
sudo apt-get install -y mongodb-enterprise
```

**指定 3.6.2 版本安装 MongoDB Enterprise**

```sh
sudo apt-get install -y mongodb-org=3.6.2 mongodb-org-server=3.6.2 mongodb-org-shell=3.6.2 mongodb-org-mongos=3.6.2 mongodb-org-tools=3.6.2
```

## 5. 启动服务

```sh
service mongod start
```

## 6. 查看日志

确认`MongoDB`已经成功启动，查看`/var/log/mongodb/mongod.log` 日志

```sh
less /var/log/mongodb/mongod.log 
```

验证 mongod 已成功启动，通过检查日志文件的内容

```sh
[initandlisten] waiting for connections on port 27017
```

`<port>`是`mongod`监听的端口。如果您修改了 配置文件中的`net.port`设置`/etc/mongod.conf`，端口可能会有所不同。

您可能会在`mongod` 输出中看到非严重警告。只要你看到上面显示的日志行，你可以放心地忽略这些警告。

# 四、MongoDB 使用

## 1. 连接 MongoDB

mongo在同一台主机上启动一个`shell mongod`。使用`--host`命令行选项指定`mongod` 监听的本地主机地址和端口：

```sh
mongo --host 127.0.0.1:27017
```

```sh
MongoDB shell version v3.6.2
connecting to: mongodb://127.0.0.1:27017/
MongoDB server version: 3.6.2
Server has startup warnings: 
2018-01-25T12:42:31.472+0000 I STORAGE  [initandlisten] 
2018-01-25T12:42:31.473+0000 I STORAGE  [initandlisten] ** WARNING: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine
2018-01-25T12:42:31.473+0000 I STORAGE  [initandlisten] **          See http://dochub.mongodb.org/core/prodnotes-filesystem
2018-01-25T12:42:31.510+0000 I CONTROL  [initandlisten] 
2018-01-25T12:42:31.510+0000 I CONTROL  [initandlisten] ** WARNING: Access control is not enabled for the database.
2018-01-25T12:42:31.510+0000 I CONTROL  [initandlisten] **          Read and write access to data and configuration is unrestricted.
2018-01-25T12:42:31.510+0000 I CONTROL  [initandlisten] 
2018-01-25T12:42:31.511+0000 I CONTROL  [initandlisten] 
2018-01-25T12:42:31.511+0000 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/enabled is 'always'.
2018-01-25T12:42:31.511+0000 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2018-01-25T12:42:31.511+0000 I CONTROL  [initandlisten] 
2018-01-25T12:42:31.511+0000 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/defrag is 'always'.
2018-01-25T12:42:31.511+0000 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2018-01-25T12:42:31.511+0000 I CONTROL  [initandlisten] 
> 1+1
2
```
上面简单测试了：1+1

**退出：Ctrl+c**

## 2. MongoDB 创建数据库 

语法

```sh
use DATABASE_NAME
```

创建一个 `souyunku` 的数据库，使用 `db` 命令查看

```sh
> use souyunku
switched to db souyunku
> db
souyunku
>
```

查看所有数据库使用`show dbs` 

```sh
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
test    0.000GB
> 
```

可以看到，刚创建的数据库 `souyunku` 并不在数据库的列表中， 要显示它，我们需要向 souyunku 数据库插入一些数据。

```sh
> db.souyunku.insert({"name":"关注公众号，搜云库，专注于开发技术的研究与知识分享"})
WriteResult({ "nInserted" : 1 })
> show dbs
admin     0.000GB
config    0.000GB
local     0.000GB
souyunku  0.000GB
test      0.000GB
>
```

`MongoDB` 中默认的数据库为 `test`，如果你没有创建新的数据库，集合将存放在 `test` 数据库中。

## 3. MongoDB 删除数据库

**`MongoDB` 删除数据库的语法**

```sh
db.dropDatabase()
```
实例

以下操作会把`souyunku` 数据删除

查看所有数据库

```sh
> show dbs
admin     0.000GB
config    0.000GB
local     0.000GB
souyunku  0.000GB
test      0.000GB
```

切换到`souyunku` 数据库

```sh
> use souyunku
switched to db souyunku
```

使用`db.dropDatabase()` 删除数据库

```sh
> db.dropDatabase()
{ "dropped" : "souyunku", "ok" : 1 }
```

看到已经删除了

```sh
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
test    0.000GB
> 
```

## 4. MongoDB 插入文档

`MongoDB` 使用 `insert()` 或 `save()` 方法向集合中插入文档，语法如下：

```sh
db.COLLECTION_NAME.insert(document)
```

以下文档可以存储在 `MongoDB` 的 `souyunku`数据库 的 `col` 集合中：

切换到`souyunku` 数据库

```sh
> use souyunku
switched to db souyunku
```

```sh
db.col.insert({title: 'MongoDB 教程', 
    description: 'MongoDB 是一个 Nosql 数据库',
    by: '搜云库教程-专注于开发技术的研究与知识分享',
    url: 'http://www.souyunku.com',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 100
})
```

```sh
> db.col.find()
```

以上实例中 `col` 是我们的集合名，如果该集合不在该数据库中， `MongoDB` 会自动创建该集合并插入文档。
查看已插入文档：

响应

```sh
{
	"_id": ObjectId("5a69eb32ec3046ee8ae54dbb"),
	"title": "MongoDB 教程",
	"description": "MongoDB 是一个 Nosql 数据库",
	"by": "搜云库教程-专注于开发技术的研究与知识分享",
	"url": "http://www.souyunku.com",
	"tags": ["mongodb", "database", "NoSQL"],
	"likes": 100
}
>
```

我们也可以将数据定义为一个变量，如下所示：

```sh
document=({title: 'MongoDB 教程', 
    description: 'MongoDB 是一个 Nosql 数据库',
    by: '搜云库教程-专注于开发技术的研究与知识分享',
    url: 'http://www.souyunku.com',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 100
})
```

执行后显示结果如下：

```sh
{
	"title" : "MongoDB 教程",
	"description" : "MongoDB 是一个 Nosql 数据库",
	"by" : "搜云库教程-专注于开发技术的研究与知识分享",
	"url" : "http://www.souyunku.com",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 100
}
```

执行插入操作：

```sh
> db.col.insert(document)
WriteResult({ "nInserted" : 1 })
> 
```

插入文档你也可以使用 `db.col.save(document)` 命令。如果不指定 `_id` 字段 `save()` 方法类似于 `insert()` 方法。如果指定 `_id` 字段，则会更新该 `_id` 的数据。


**3.2 版本后还有以下几种语法可用于插入文档:**

`db.collection.insertOne()`:向指定集合中插入一条文档数据。
 
`db.collection.insertMany()`:向指定集合中插入多条文档数据。


插入单条数据

```sh
> var document = db.collection.insertOne({"title": "搜云库"})
> document
{
	"acknowledged" : true,
	"insertedId" : ObjectId("5a69f0dfec3046ee8ae54dbe")
}
> db.collection.find()
{ "_id" : ObjectId("5a69f0dfec3046ee8ae54dbe"), "title" : "搜云库" }
>
```


插入多条数据

```sh
> var res = db.collection.insertMany([{"title": "搜云库"}, {'description': "关注公众号，搜云库，专注于开发技术的研究与知识分享"}])
> res
{
	"acknowledged" : true,
	"insertedIds" : [
		ObjectId("5a69f188ec3046ee8ae54dbf"),
		ObjectId("5a69f188ec3046ee8ae54dc0")
	]
}
> db.collection.find()
{ "_id" : ObjectId("5a69f0dfec3046ee8ae54dbe"), "title" : "搜云库" }
{ "_id" : ObjectId("5a69f188ec3046ee8ae54dc0"), "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享" }
> 
```

## 5. MongoDB 删除文档

`MongoDB remove()`函数是用来移除集合中的数据。

`MongoDB`数据更新可以使用`update()`函数。在执行`remove()`函数前先执行`find()`命令来判断执行的条件是否正确，这是一个比较好的习惯。

**`remove()` 方法已经过时了，现在官方推荐使用 `deleteOne()` 和 `deleteMany()` 方法。**

如删除集合下全部文档：

```sh
> db.col.deleteMany({})
{ "acknowledged" : true, "deletedCount" : 2 }
> db.col.find()
> 
```

删除 `title` 等于 "搜云库" 的全部文档：

```
> db.collection.deleteMany({ title : "搜云库"})
{ "acknowledged" : true, "deletedCount" : 2 }
> 
> db.collection.find()
{ "_id" : ObjectId("5a69f188ec3046ee8ae54dc0"), "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享" }
> 
```

删除 `weixin` 等于 "souyunku" 的一个文档：

```sh
> db.col.insert({weixin:"souyunku"})
WriteResult({ "nInserted" : 1 })
> db.col.find()
{ "_id" : ObjectId("5a69f5a0ec3046ee8ae54dc1"), "weixin" : "souyunku" }
> db.col.deleteOne({weixin:"souyunku"})
{ "acknowledged" : true, "deletedCount" : 1 }
> db.col.find()
>
```

## 6. MongoDB 查询文档

`MongoDB` 查询文档使用 `find()` 方法。

`find()` 方法以非结构化的方式来显示所有文档。

语法

MongoDB 查询数据的语法格式如下：

```sh
> db.collection.find(query, projection)
```

- `query` ：可选，使用查询操作符指定查询条件
- `projection` ：可选，使用投影操作符指定返回的键。查询时返回文档中所有键值， 只需省略该参数即可（默认省略）。

pretty() 方法以格式化的方式来显示所有文档。

```sh
db.col.insert({title: 'MongoDB 教程', 
    description: 'MongoDB 是一个 Nosql 数据库',
    by: '搜云库教程-专注于开发技术的研究与知识分享',
    url: 'http://www.souyunku.com',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 100
})
```

```sh
> db.col.find().pretty()
{
	"_id" : ObjectId("5a69f93598891b4abe9cc8cb"),
	"title" : "MongoDB 教程",
	"description" : "MongoDB 是一个 Nosql 数据库",
	"by" : "搜云库教程-专注于开发技术的研究与知识分享",
	"url" : "http://www.souyunku.com",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 100
}
```

**MongoDB 与 RDBMS Where 语句比较**

![paste image](http://oisa91ton.bkt.clouddn.com/1516945200213ih4iyhp0.png?imageslim)

### 6.1 MongoDB AND 条件

MongoDB 的 find() 方法可以传入多个键(key)，每个键(key)以逗号隔开，即常规 SQL 的 AND 条件。

语法格式如下：

```sh
> db.col.find({key1:value1, key2:value2}).pretty()
```

实例

以下实例通过 `by` 和 `title` 键来查询 数据

```sh
> db.col.find({"by":"搜云库教程-专注于开发技术的研究与知识分享", "title":"MongoDB 教程"}).pretty()
{
	"_id" : ObjectId("5a69f93598891b4abe9cc8cb"),
	"title" : "MongoDB 教程",
	"description" : "MongoDB 是一个 Nosql 数据库",
	"by" : "搜云库教程-专注于开发技术的研究与知识分享",
	"url" : "http://www.souyunku.com",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 100
}
```

以上实例中类似于 WHERE 语句：WHERE by='搜云库教程-专注于开发技术的研究与知识分享' AND title='MongoDB 教程'

### 6.2 MongoDB OR 条件

MongoDB OR 条件语句使用了关键字 $or,语法格式如下：

```sh
>db.col.find(
   {
      $or: [
         {key1: value1}, {key2:value2}
      ]
   }
).pretty
```

实例

以下实例中，我们演示了查询键 **by** 值为 "搜云库教程-专注于开发技术的研究与知识分享" 或键 **title** 值为 **MongoDB 教程** 的文档。

```sh
> db.col.find({$or:[{"by":"搜云库教程-专注于开发技术的研究与知识分享"},{"title": "MongoDB 教程"}]}).pretty()
{
	"_id" : ObjectId("5a69f93598891b4abe9cc8cb"),
	"title" : "MongoDB 教程",
	"description" : "MongoDB 是一个 Nosql 数据库",
	"by" : "搜云库教程-专注于开发技术的研究与知识分享",
	"url" : "http://www.souyunku.com",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 100
}
> 
```

### 6.3 AND 和 OR 联合使用

以下实例演示了 `AND` 和 `OR` 联合使用，类似常规 `SQL` 语句为： `'where likes>50 AND (by = '搜云库教程-专注于开发技术的研究与知识分享' OR title = 'MongoDB 教程')'`

```sh
> db.col.find({"likes": {$gt:50}, $or: [{"by": "搜云库教程-专注于开发技术的研究与知识分享"},{"title": "MongoDB 教程"}]}).pretty()
{
	"_id" : ObjectId("5a69f93598891b4abe9cc8cb"),
	"title" : "MongoDB 教程",
	"description" : "MongoDB 是一个 Nosql 数据库",
	"by" : "搜云库教程-专注于开发技术的研究与知识分享",
	"url" : "http://www.souyunku.com",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 100
}
> 
```

## 7. MongoDB 条件操作符

条件操作符用于比较两个表达式并从`MongoDB`集合中获取数据。

`MongoDB`中条件操作符有：

```sh
(>) 大于 - $gt
(<) 小于 - $lt
(>=) 大于等于 - $gte
(<= ) 小于等于 - $lte
```

清空集合数据

```sh
db.col.remove({})
```

插入以下数据

```sh
> db.col.insert({
    title: '测试数据200', 
    description: '关注公众号，搜云库，专注于开发技术的研究与知识分享',
    by: '搜云库',
    url: 'http://www.souyunku.com',
    tags: ['test'],
    likes: 200
})
```

```sh
> db.col.insert({
	title: '测试数据150', 
    description: '关注公众号，搜云库，专注于开发技术的研究与知识分享',
    by: '搜云库',
    url: 'http://www.souyunku.com',
    tags: ['test'],
    likes: 150
})
```

```sh
> db.col.insert({
	title: '测试数据100', 
    description: '关注公众号，搜云库，专注于开发技术的研究与知识分享',
    by: '搜云库',
    url: 'http://www.souyunku.com',
    tags: ['test'],
    likes: 100
})
```

使用find()命令查看数据：

```sh
> db.col.find()
{ "_id" : ObjectId("5a6a083598891b4abe9cc8cc"), "title" : "测试数据200", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 200 }
{ "_id" : ObjectId("5a6a083e98891b4abe9cc8cd"), "title" : "测试数据150", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 150 }
{ "_id" : ObjectId("5a6a084498891b4abe9cc8ce"), "title" : "测试数据100", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 100 }
> 
```

### 7.1 MongoDB (>) 大于操作符 - $gt

```sh
db.col.find({"likes" : {$gt : 100}})
```
类似于SQL语句：

```sh
select * from col where likes > 100;
```

输出结果

```sh
{ "_id" : ObjectId("5a6a083598891b4abe9cc8cc"), "title" : "测试数据200", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 200 }
{ "_id" : ObjectId("5a6a083e98891b4abe9cc8cd"), "title" : "测试数据150", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 150 }
>
```

### 7.2 MongoDB（>=）大于等于操作符 - $gte

如果你想获取"col"集合中 "likes" 大于等于 100 的数据，你可以使用以下命令：

```sh
db.col.find({likes : {$gte : 100}})
```

类似于SQL语句：

```sh
select * from col where likes >=100;
```

输出结果：

```sh
{ "_id" : ObjectId("5a6a083598891b4abe9cc8cc"), "title" : "测试数据200", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 200 }
{ "_id" : ObjectId("5a6a083e98891b4abe9cc8cd"), "title" : "测试数据150", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 150 }
{ "_id" : ObjectId("5a6a084498891b4abe9cc8ce"), "title" : "测试数据100", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 100 }
>
```
### 7.3 MongoDB (<) 小于操作符 - $lt

如果你想获取"col"集合中 "likes" 小于 150 的数据，你可以使用以下命令：

```sh
db.col.find({likes : {$lt : 150}})
```

类似于SQL语句：

```sh
select * from col where likes < 150;
```
输出结果：

```sh
> db.col.find({likes : {$lt : 150}})
{ "_id" : ObjectId("5a6a084498891b4abe9cc8ce"), "title" : "测试数据100", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 100 }
> 
```

### 7.4 MongoDB (<=) 小于操作符 - $lte

如果你想获取"col"集合中 "likes" 小于等于 150 的数据，你可以使用以下命令

```sh
db.col.find({likes : {$lte : 150}})
```

类似于SQL语句：

```sh
select * from col where likes <= 150;
```

输出结果：

```sh
> db.col.find({likes : {$lte : 150}})
{ "_id" : ObjectId("5a6a083e98891b4abe9cc8cd"), "title" : "测试数据150", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 150 }
{ "_id" : ObjectId("5a6a084498891b4abe9cc8ce"), "title" : "测试数据100", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 100 }
> 
```

### 7.5 MongoDB 使用 (<) 和 (>) 查询 - $lt 和 $gt

如果你想获取"col"集合中 "likes" 大于100，小于 200 的数据，你可以使用以下命令：

```sh
db.col.find({likes : {$lt :200, $gt : 100}})
```

类似于SQL语句：

```sh
select * from col where likes>100 AND  likes<200;
```

输出结果：

```sh
> db.col.find({likes : {$lt :200, $gt : 100}})
{ "_id" : ObjectId("5a6a083e98891b4abe9cc8cd"), "title" : "测试数据150", "description" : "关注公众号，搜云库，专注于开发技术的研究与知识分享", "by" : "搜云库", "url" : "http://www.souyunku.com", "tags" : [ "test" ], "likes" : 150 }
> 
```

一些简写说明：

```sh
$gt -------- greater than  >

$gte --------- gt equal  >=

$lt -------- less than  <

$lte --------- lt equal  <=

$ne ----------- not equal  !=

$eq  --------  equal  =
```

[1]: http://www.ymq.io/images/2018/MongoDB/1.png
[2]: http://www.ymq.io/images/2018/MongoDB/2.png


**参考：**

Runoob 教程：http://www.runoob.com/mongodb/mongodb-tutorial.html  
Tutorials 教程：Pointhttps://www.tutorialspoint.com/mongodb/mongodb_advantages.htm  
MongoDB 官网地址：https://www.mongodb.com  
MongoDB 官方英文文档：https://docs.mongodb.com/manual  
MongoDB 各平台下载地址：https://www.mongodb.com/download-center#community  
MongoDB 安装 https://docs.mongodb.com/manual/tutorial/install-mongodb-enterprise-on-ubuntu