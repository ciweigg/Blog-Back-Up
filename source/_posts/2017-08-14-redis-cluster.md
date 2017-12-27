layout: post
title: CentOs7.3 搭建 Redis-4.0.1 Cluster 集群服务
categories: Redis
description: CentOs7.3 搭建 Redis-4.0.1 Cluster 集群服务
keywords: Redis
date: 2017-12-23 12:30:55
---
# CentOs7.3 搭建 Redis-4.0.1 Cluster 集群服务

## Redis 简介

Redis 是完全开源免费的，遵守BSD协议，是一个高性能的key-value数据库。

Redis 与其他 key - value 缓存产品有以下三个特点：
Redis支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用。
Redis不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。
Redis支持数据的备份，即master-slave模式的数据备份。

<!-- more -->

## Redis 优势

性能极高 – Redis能读的速度是110000次/s,写的速度是81000次/s 。
丰富的数据类型 – Redis支持二进制案例的 Strings, Lists, Hashes, Sets 及 Ordered Sets 数据类型操作。
原子 – Redis的所有操作都是原子性的，同时Redis还支持对几个操作全并后的原子性执行。
丰富的特性 – Redis还支持 publish/subscribe, 通知, key 过期等等特性。

## Redis与其他key-value存储有什么不同？

Redis有着更为复杂的数据结构并且提供对他们的原子性操作，这是一个不同于其他数据库的进化路径。Redis的数据类型都是基于基本数据结构的同时对程序员透明，无需进行额外的抽象。
Redis运行在内存中但是可以持久化到磁盘，所以在对不同数据集进行高速读写时需要权衡内存，应为数据量不能大于硬件内存。在内存数据库方面的另一个优点是， 相比在磁盘上相同的复杂的数据结构，在内存中操作起来非常简单，这样Redis可以做很多内部复杂性很强的事情。 同时，在磁盘格式方面他们是紧凑的以追加的方式产生的，因为他们并不需要进行随机访问。

## 环境

 - VMware版本号：12.0.0
 - CentOS版本：CentOS 7.3.1611
 - 三台虚拟机(IP)：192.168.252.101,192.168.102..102,192.168.252.103

### 注意事项
 
升级所有的包，防止出现版本过久不兼容问题

```sh
$ yum -y update
```

安裝 GCC 编译工具 不然会有编译不过的问题

```sh
$ yum install -y gcc g++ gcc-c++ make
```

关闭防火墙 节点之前需要开放指定端口，为了方便，生产不要禁用

centos 6.x

```
$ service iptables stop # 关闭命令：
```

centos 7.x
```
$ systemctl stop firewalld.service # 停止firewall
```



## 集群搭建

### 安装 Redis

**下载，解压，编译安装**

```sh
cd /opt
$ wget http://download.redis.io/releases/redis-4.0.1.tar.gz
$ tar xzf redis-4.0.1.tar.gz
$ cd redis-4.0.1
$ make
```

**如果因为上次编译失败，有残留的文件**
 
```sh
$ make distclean
```


### 创建节点

1.首先在 192.168.252.101机器上 /opt/redis-4.0.1目录下创建 `redis-cluster` 目录

```sh
$ mkdir /opt/redis-4.0.1/redis-cluster
```

2.在 `redis-cluster` 目录下，创建名为`7000、7001、7002`的目录

```sh
$ cd /opt/redis-4.0.1/redis-cluster
$ mkdir 7000 7001 7002

```

3.分别修改这三个配置文件，把如下`redis.conf 配置`内容粘贴进去
 
```sh
$ vi 7000/redis.conf 
$ vi 7001/redis.conf
$ vi 7002/redis.conf
```

**redis.conf 配置**


```sh
port 7000
bind 192.168.252.101
daemonize yes
pidfile /var/run/redis_7000.pid
cluster-enabled yes
cluster-config-file nodes_7000.conf
cluster-node-timeout 10100
appendonly yes

```

**redis.conf 配置说明**

```sh
#端口7000,7001,7002
port 7000

#默认ip为127.0.0.1，需要改为其他节点机器可访问的ip，否则创建集群时无法访问对应的端口，无法创建集群
bind 192.168.252.101

#redis后台运行
daemonize yes

#pidfile文件对应7000，7001，7002
pidfile /var/run/redis_7000.pid

#开启集群，把注释#去掉
cluster-enabled yes

#集群的配置，配置文件首次启动自动生成 7000，7001，7002          
cluster-config-file nodes_7000.conf

#请求超时，默认15秒，可自行设置 
cluster-node-timeout 10100    
        
#aof日志开启，有需要就开启，它会每次写操作都记录一条日志
appendonly yes
```

···
**接着在另外两台机器上`(192.168.252.102，192.168.252.103)`重复以上三步，只是把目录改为`7003、7004、7005、7006、7007、7008`对应的配置文件也按照这个规则修改即可**



### 启动集群

```sh
#第一台机器上执行 3个节点
$ for((i=0;i<=2;i++)); do /opt/redis-4.0.1/src/redis-server /opt/redis-4.0.1/redis-cluster/700$i/redis.conf; done

#第二台机器上执行 3个节点
$ for((i=3;i<=5;i++)); do /opt/redis-4.0.1/src/redis-server /opt/redis-4.0.1/redis-cluster/700$i/redis.conf; done
                     
#第三台机器上执行 3个节点 
$ for((i=6;i<=8;i++)); do /opt/redis-4.0.1/src/redis-server /opt/redis-4.0.1/redis-cluster/700$i/redis.conf; done
```

### 检查服务

检查各 Redis 各个节点启动情况
 
```sh
$ ps -ef | grep redis           //redis是否启动成功
$ netstat -tnlp | grep redis    //监听redis端口
```

### 安装 Ruby

```sh
$ yum -y install ruby ruby-devel rubygems rpm-build
$ gem install redis
```

### 创建集群

**注意：在任意一台上运行** 不要在每台机器上都运行，一台就够了
 
Redis 官方提供了 `redis-trib.rb` 这个工具，就在解压目录的 src 目录中
 
```sh
$ /opt/redis-4.0.1/src/redis-trib.rb create --replicas 1 192.168.252.101:7000 192.168.252.101:7001 192.168.252.101:7002 192.168.252.102:7003 192.168.252.102:7004 192.168.252.102:7005 192.168.252.103:7006 192.168.252.103:7007 192.168.252.103:7008
```

出现以下内容

```sh
[root@localhost redis-cluster]# /opt/redis-4.0.1/src/redis-trib.rb create --replicas 1 192.168.252.101:7000 192.168.252.101:7001 192.168.252.101:7002 192.168.252.102:7003 192.168.252.102:7004 192.168.252.102:7005 192.168.252.103:7006 192.168.252.103:7007 192.168.252.103:7008
>>> Creating cluster
>>> Performing hash slots allocation on 9 nodes...
Using 4 masters:
192.168.252.101:7000
192.168.252.102:7003
192.168.252.103:7006
192.168.252.101:7001
Adding replica 192.168.252.102:7004 to 192.168.252.101:7000
Adding replica 192.168.252.103:7007 to 192.168.252.102:7003
Adding replica 192.168.252.101:7002 to 192.168.252.103:7006
Adding replica 192.168.252.102:7005 to 192.168.252.101:7001
Adding replica 192.168.252.103:7008 to 192.168.252.101:7000
M: 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf 192.168.252.101:7000
   slots:0-4095 (4096 slots) master
M: 44c81c15b01d992cb9ede4ad35477ec853d70723 192.168.252.101:7001
   slots:12288-16383 (4096 slots) master
S: 38f03c27af39723e1828eb62d1775c4b6e2c3638 192.168.252.101:7002
   replicates f1abb62a8c9b448ea14db421bdfe3f1d8075189c
M: 987965baf505a9aa43e50e46c76189c51a8f17ec 192.168.252.102:7003
   slots:4096-8191 (4096 slots) master
S: 6555292fed9c5d52fcf5b983c441aff6f96923d5 192.168.252.102:7004
   replicates 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf
S: 2b5ba254a0405d4efde4c459867b15176f79244a 192.168.252.102:7005
   replicates 44c81c15b01d992cb9ede4ad35477ec853d70723
M: f1abb62a8c9b448ea14db421bdfe3f1d8075189c 192.168.252.103:7006
   slots:8192-12287 (4096 slots) master
S: eb4067373d36d8a8df07951f92794e67a6aac022 192.168.252.103:7007
   replicates 987965baf505a9aa43e50e46c76189c51a8f17ec
S: 2919e041dd3d1daf176d6800dcd262f4e727f366 192.168.252.103:7008
   replicates 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf
Can I set the above configuration? (type 'yes' to accept): yes

```

**输入 yes**

```sh
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join.........
>>> Performing Cluster Check (using node 192.168.252.101:7000)
M: 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf 192.168.252.101:7000
   slots:0-4095 (4096 slots) master
   2 additional replica(s)
S: 6555292fed9c5d52fcf5b983c441aff6f96923d5 192.168.252.102:7004
   slots: (0 slots) slave
   replicates 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf
M: 44c81c15b01d992cb9ede4ad35477ec853d70723 192.168.252.101:7001
   slots:12288-16383 (4096 slots) master
   1 additional replica(s)
S: 2919e041dd3d1daf176d6800dcd262f4e727f366 192.168.252.103:7008
   slots: (0 slots) slave
   replicates 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf
M: f1abb62a8c9b448ea14db421bdfe3f1d8075189c 192.168.252.103:7006
   slots:8192-12287 (4096 slots) master
   1 additional replica(s)
S: eb4067373d36d8a8df07951f92794e67a6aac022 192.168.252.103:7007
   slots: (0 slots) slave
   replicates 987965baf505a9aa43e50e46c76189c51a8f17ec
S: 38f03c27af39723e1828eb62d1775c4b6e2c3638 192.168.252.101:7002
   slots: (0 slots) slave
   replicates f1abb62a8c9b448ea14db421bdfe3f1d8075189c
S: 2b5ba254a0405d4efde4c459867b15176f79244a 192.168.252.102:7005
   slots: (0 slots) slave
   replicates 44c81c15b01d992cb9ede4ad35477ec853d70723
M: 987965baf505a9aa43e50e46c76189c51a8f17ec 192.168.252.102:7003
   slots:4096-8191 (4096 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```




### 关闭集群

这样也可以，推荐

```sh
$ pkill redis
```

循环节点逐个关闭

```sh
$ for((i=0;i<=2;i++)); do /opt/redis-4.0.1/src/redis-cli -c -h 192.168.252.101 -p 700$i shutdown; done

$ for((i=3;i<=5;i++)); do /opt/redis-4.0.1/src/redis-cli -c -h 192.168.252.102 -p 700$i shutdown; done

$ for((i=6;i<=8;i++)); do /opt/redis-4.0.1/src/redis-cli -c -h 192.168.252.103 -p 700$i shutdown; done
```


## 集群验证

 
### 连接集群测试
 
参数 -C 可连接到集群，因为 redis.conf 将 bind 改为了ip地址，所以 -h 参数不可以省略，-p 参数为端口号
 
 
 - **我们在192.168.252.101机器redis 7000 的节点set 一个key**

```sh
$ /opt/redis-4.0.1/src/redis-cli -h 192.168.252.101 -c -p 7000
192.168.252.101:7000> set name www.ymq.io
-> Redirected to slot [5798] located at 192.168.252.102:7003
OK
192.168.252.102:7003> get name
"www.ymq.io"
192.168.252.102:7003>
```
发现redis set name 之后重定向到192.168.252.102机器 redis 7003 这个节点


 - **我们在192.168.252.103机器redis 7008 的节点get一个key**

```sh
[root@localhost redis-cluster]# /opt/redis-4.0.1/src/redis-cli -h 192.168.252.103 -c -p 7008
192.168.252.103:7008> get name
-> Redirected to slot [5798] located at 192.168.252.102:7003
"www.ymq.io"
192.168.252.102:7003> 
```

发现redis get name 重定向到192.168.252.102机器 redis 7003 这个节点

 > 如果您看到这样的现象，说明集群已经是可用的了




### 检查集群状态
 
```sh
$ /opt/redis-4.0.1/src/redis-trib.rb check 192.168.252.101:7000
```

```sh
>>> Performing Cluster Check (using node 192.168.252.101:7000)
M: 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf 192.168.252.101:7000
   slots:0-4095 (4096 slots) master
   2 additional replica(s)
S: 6555292fed9c5d52fcf5b983c441aff6f96923d5 192.168.252.102:7004
   slots: (0 slots) slave
   replicates 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf
M: 44c81c15b01d992cb9ede4ad35477ec853d70723 192.168.252.101:7001
   slots:12288-16383 (4096 slots) master
   1 additional replica(s)
S: 2919e041dd3d1daf176d6800dcd262f4e727f366 192.168.252.103:7008
   slots: (0 slots) slave
   replicates 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf
M: f1abb62a8c9b448ea14db421bdfe3f1d8075189c 192.168.252.103:7006
   slots:8192-12287 (4096 slots) master
   1 additional replica(s)
S: eb4067373d36d8a8df07951f92794e67a6aac022 192.168.252.103:7007
   slots: (0 slots) slave
   replicates 987965baf505a9aa43e50e46c76189c51a8f17ec
S: 38f03c27af39723e1828eb62d1775c4b6e2c3638 192.168.252.101:7002
   slots: (0 slots) slave
   replicates f1abb62a8c9b448ea14db421bdfe3f1d8075189c
S: 2b5ba254a0405d4efde4c459867b15176f79244a 192.168.252.102:7005
   slots: (0 slots) slave
   replicates 44c81c15b01d992cb9ede4ad35477ec853d70723
M: 987965baf505a9aa43e50e46c76189c51a8f17ec 192.168.252.102:7003
   slots:4096-8191 (4096 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

```

### 列出集群节点

列出集群当前已知的所有节点（node），以及这些节点的相关信息
 
```sh
$ /opt/redis-4.0.1/src/redis-cli -h 192.168.252.101 -c -p 7000

192.168.252.101:7000> cluster nodes
```
```sh
6555292fed9c5d52fcf5b983c441aff6f96923d5 192.168.252.102:7004@17004 slave 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf 0 1502815268317 5 connected
44c81c15b01d992cb9ede4ad35477ec853d70723 192.168.252.101:7001@17001 master - 0 1502815268000 2 connected 12288-16383
2919e041dd3d1daf176d6800dcd262f4e727f366 192.168.252.103:7008@17008 slave 7c622ac191edd40dd61d9b79b27f6f69d02a5bbf 0 1502815269000 9 connected
7c622ac191edd40dd61d9b79b27f6f69d02a5bbf 192.168.252.101:7000@17000 myself,master - 0 1502815269000 1 connected 0-4095
f1abb62a8c9b448ea14db421bdfe3f1d8075189c 192.168.252.103:7006@17006 master - 0 1502815269000 7 connected 8192-12287
eb4067373d36d8a8df07951f92794e67a6aac022 192.168.252.103:7007@17007 slave 987965baf505a9aa43e50e46c76189c51a8f17ec 0 1502815267000 8 connected
38f03c27af39723e1828eb62d1775c4b6e2c3638 192.168.252.101:7002@17002 slave f1abb62a8c9b448ea14db421bdfe3f1d8075189c 0 1502815269327 7 connected
2b5ba254a0405d4efde4c459867b15176f79244a 192.168.252.102:7005@17005 slave 44c81c15b01d992cb9ede4ad35477ec853d70723 0 1502815270336 6 connected
987965baf505a9aa43e50e46c76189c51a8f17ec 192.168.252.102:7003@17003 master - 0 1502815271345 4 connected 4096-8191
192.168.252.101:7000> 

```
### 打印集群信息 
 
```sh
$ 192.168.252.101:7000> cluster info
```

```sh
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:9
cluster_size:4
cluster_current_epoch:9
cluster_my_epoch:1
cluster_stats_messages_ping_sent:485
cluster_stats_messages_pong_sent:485
cluster_stats_messages_sent:970
cluster_stats_messages_ping_received:477
cluster_stats_messages_pong_received:485
cluster_stats_messages_meet_received:8
cluster_stats_messages_received:970
192.168.252.101:7000> 
```

## 集群命令

语法格式
```sh
redis-cli -c -p port
```

### 集群
```
cluster info ：打印集群的信息
cluster nodes ：列出集群当前已知的所有节点（ node），以及这些节点的相关信息。
```

### 节点

```
cluster meet <ip> <port> ：将 ip 和 port 所指定的节点添加到集群当中，让它成为集群的一份子。
cluster forget <node_id> ：从集群中移除 node_id 指定的节点。
cluster replicate <node_id> ：将当前节点设置为 node_id 指定的节点的从节点。
cluster saveconfig ：将节点的配置文件保存到硬盘里面。

```

### 槽(slot)

```
cluster addslots <slot> [slot ...] ：将一个或多个槽（ slot）指派（ assign）给当前节点。
cluster delslots <slot> [slot ...] ：移除一个或多个槽对当前节点的指派。
cluster flushslots ：移除指派给当前节点的所有槽，让当前节点变成一个没有指派任何槽的节点。
cluster setslot <slot> node <node_id> ：将槽 slot 指派给 node_id 指定的节点，如果槽已经指派给另一个节点，那么先让另一个节点删除该槽>，然后再进行指派。
cluster setslot <slot> migrating <node_id> ：将本节点的槽 slot 迁移到 node_id 指定的节点中。
cluster setslot <slot> importing <node_id> ：从 node_id 指定的节点中导入槽 slot 到本节点。
cluster setslot <slot> stable ：取消对槽 slot 的导入（ import）或者迁移（ migrate）。
```

### 键
```
cluster keyslot <key> ：计算键 key 应该被放置在哪个槽上。
cluster countkeysinslot <slot> ：返回槽 slot 目前包含的键值对数量。
cluster getkeysinslot <slot> <count> ：返回 count 个 slot 槽中的键 。
```

出处：http://www.ymq.io
转自：鹏磊