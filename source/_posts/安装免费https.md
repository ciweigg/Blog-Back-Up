title: 安装免费https
date: 2018-01-05 15:52:17
tags: [https]
categories: [https]
---
acme.sh 实现了 acme 协议, 可以从 letsencrypt 生成免费的证书. https://github.com/Neilpang/acme.sh
给acme.sh组织赞助：Acknowledgments
<!--more-->
很简单就两个步骤:
### 1. 安装 acme.sh
curl  https://get.acme.sh | sh
这条命令，会做的事情
1.把 acme.sh 安装到你的 home 目录下： 并创建 一个 bash 的 alias, 方便你的使用: acme.sh=~/.acme.sh/acme.sh
2.自动为你创建 cronjob, 每天 0:00 点自动检测所有的证书, 如果快过期了, 需要更新, 则会自动更新证书.
### 2. 生成证书，及验证证书
如果你还没有运行任何 web 服务, 且80 端口是空闲的, 那么 acme.sh 能假装自己是一个webserver, 临时听在80 端口, 完成验证:
注意：如果您使用的时候，请把，hub.ymq.io 替换成自己域名，此域名需要dns 解析到安装私有仓库的服务器IP
```
$ cd ~/.acme.sh/
$ apt-get install socat
$ sh acme.sh  --issue -d hub.ymq.io   --standalone
```
如果看到如下信息，说明证书验证并生成成功,证书生成位置在：/root/.acme.sh/hub.ymq.io/ 下
```
Success
Verify finished, start to sign.
Cert success.
-----BEGIN CERTIFICATE-----
[Wed Jan  3 14:36:25 UTC 2018] Standalone mode.
[Wed Jan  3 14:36:25 UTC 2018] Registering account
[Wed Jan  3 14:36:27 UTC 2018] Registered
[Wed Jan  3 14:36:27 UTC 2018] ACCOUNT_THUMBPRINT='7TpUIE5N--hq2nhk2ruKmHBfgKB-LX-pBCkWzzmHzVM'
[Wed Jan  3 14:36:27 UTC 2018] Creating domain key
[Wed Jan  3 14:36:28 UTC 2018] The domain key is here: /root/.acme.sh/hub.ymq.io/hub.ymq.io.key
[Wed Jan  3 14:36:28 UTC 2018] Single domain='hub.ymq.io'
[Wed Jan  3 14:36:28 UTC 2018] Getting domain auth token for each domain
[Wed Jan  3 14:36:28 UTC 2018] Getting webroot for domain='hub.ymq.io'
[Wed Jan  3 14:36:28 UTC 2018] Getting new-authz for domain='hub.ymq.io'
[Wed Jan  3 14:36:29 UTC 2018] The new-authz request is ok.
[Wed Jan  3 14:36:29 UTC 2018] Verifying:hub.ymq.io
[Wed Jan  3 14:36:29 UTC 2018] Standalone mode server
[Wed Jan  3 14:36:34 UTC 2018] Success
[Wed Jan  3 14:36:34 UTC 2018] Verify finished, start to sign.
[Wed Jan  3 14:36:35 UTC 2018] Cert success.
-----BEGIN CERTIFICATE-----
MIIE9zCCA9+gAwIBAgISA6WV4ZFi6lr/kngVGx7/FoPMMA0GCSqGSIb3DQEBCwUA
******************************************
...

-----END CERTIFICATE-----
[Wed Jan  3 14:36:35 UTC 2018] Your cert is in  /root/.acme.sh/hub.ymq.io/hub.ymq.io.cer 
[Wed Jan  3 14:36:35 UTC 2018] Your cert key is in  /root/.acme.sh/hub.ymq.io/hub.ymq.io.key 
[Wed Jan  3 14:36:35 UTC 2018] The intermediate CA cert is in  /root/.acme.sh/hub.ymq.io/ca.cer 
[Wed Jan  3 14:36:35 UTC 2018] And the full chain certs is there:  /root/.acme.sh/hub.ymq.io/fullchain.cer 
```
### 配置nginx
安装nginx自行百度
cd conf.d/
touch ssl.conf
vi ssl.conf

```
server{  
    listen 80;
    listen [::]:80 ssl ipv6only=on; 
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on;
    server_name 123.206.103.20;
    access_log  /var/log/nginx/melog.log  main;

    ssl on;
    ssl_certificate /etc/ssl/private/example_com.crt;
    ssl_certificate_key /etc/ssl/private/example_com.key;
}
```

systemctl restart nginx


