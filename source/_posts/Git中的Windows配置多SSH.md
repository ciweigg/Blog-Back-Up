title: Git中的Windows配置多SSH
author: Ciwei
tags:
  - Git
categories:
  - Git
date: 2017-12-31 11:11:00
---
多账号配置SSH
修改~/.ssh/config文件(Windows平台)
<!--more-->
# 配置 Github.com
```
Host github.com
     HostName github.com
     IdentityFile C:\\path\\to\\.ssh\\id_rsa_github
     PreferredAuthentications publickey
     User YourName
# 配置 Coding.net
Host git.coding.net
     HostName git.coding.net
     IdentityFile C:\\path\\to\\.ssh\\id_rsa_coding
     PreferredAuthentications publickey
     User YourName
# 配置 Gitee.com
Host gitee.com
     HostName gitee.com
     IdentityFile C:\\path\\to\\.ssh\\id_rsa_gitee
     PreferredAuthentications publickey
     User YourName
```
pull 强制覆盖本地文件
```
git fetch --all  
git reset --hard origin/master
```

push 强制覆盖远程文件
```
git push -f origin master
```
保持fork之后的项目和上游同步
团队协作，为了规范，一般都是fork组织的仓库到自己帐号下，再提交pr，组织的仓库一直保持更新，下面介绍如何保持自己fork之后的仓库与上游仓库同步。

使用 git remote -v 查看当前的远程仓库地址，输出如下：

```
origin  git@github.com:ibrother/staticblog.github.io.git (fetch)
origin  git@github.com:ibrother/staticblog.github.io.git (push)
可以看到从自己帐号 clone 下来的仓库，远程仓库地址是与自己的远程仓库绑定的
```

接下来运行:

```
git remote add upstream https://github.com/staticblog/staticblog.github.io.git
```
这条命令就算添加一个别名为 upstream（上游）的地址，指向之前 fork 的原仓库地址。git remote -v 输出如下：

```
origin  git@github.com:ibrother/staticblog.github.io.git (fetch)
origin  git@github.com:ibrother/staticblog.github.io.git (push)
upstream        https://github.com/staticblog/staticblog.github.io.git (fetch)
upstream        https://github.com/staticblog/staticblog.github.io.git (push)
```
之后运行下面几条命令，就可以保持本地仓库和上游仓库同步了

```
git fetch upstream
git checkout master
git merge upstream/master
```
接着就是熟悉的推送本地仓库到远程仓库

```
git push origin master
```