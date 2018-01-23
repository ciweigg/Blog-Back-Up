title: Centos7安装Docker
date: 2018-01-19 10:53:00
tags: [Docker]
categories: [Docker]
---
 Docker 是由 Go 语言编写，一个快速部署的 轻量级虚拟技术项目，它允许开发人员把自己的程序 和 开发环境一起打包，制作成一个 Docker 的image（镜像），这样部署到服务器上，也只需要下载这个 image 镜像将程序跑起来，免去了每次安装依赖和环境的麻烦，还能做到应用间的隔离
<!--more-->
### 下载源
```
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```

### 安装docker
```
yum  -y  install docker-engine
```

### 设置开机启动
```
systemctl enable docker.service
```

docker常用命令：
systemctl stop docker
systemctl start docker
systemctl status docker


