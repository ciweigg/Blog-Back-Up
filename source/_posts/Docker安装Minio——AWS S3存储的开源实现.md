title: Docker安装Minio——AWS S3存储的开源实现
date: 2018-01-10 11:21:15
tags: [分布式文件存储]
categories: [分布式文件存储]
---
### 首先安装docker：
[传送门](https://docs.minio.io/)

docker pull minio/minio

docker run -d -p 9000:9000 minio/minio server /data

<!--more-->

### 查看启动输出的秘钥：
docker logs festive_northcutt

这2个是用来登陆后台的，保存即可：
AccessKey
SecretKey

### 登陆后台
http://ip:9000

### java后台API
[传送门](https://docs.minio.io/docs/java-client-quickstart-guide)