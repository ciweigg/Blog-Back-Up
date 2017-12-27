layout: post
title: Git 简单命令
categories: Git
description: Git 简单命令
keywords: Git
date: 2017-12-23 12:13:24
---
### 1.添加和提交

> 下载一个项目和它的整个代码历史

``` sh
$ git clone [url]
```

> 你可以提出更改（把它们添加到暂存区），使用如下命令：

``` sh
git add <filename>
git add . (提交新添加和改动的)
```

> 这是 git 基本工作流程的第一步；使用如下命令以实际提交改动：

``` sh
git commit -m "代码提交信息"
```

 <!-- more -->

> 现在，你的改动已经提交到了 HEAD，但是还没到你的远端仓库。

### 2.推送改动

> 执行如下命令以将这些改动提交到远端仓库：

``` sh
git push origin master
```

> 可以把 master 换成你想要推送的任何分支

### 3. 查看远程仓库

``` sh
$ git remote -v
```

### 4.从远程获取最新版本到本地

> 从远程的origin仓库的master分支下载代码到本地的origin master

``` sh
$ git fetch origin master
```

### 5. 比较本地的仓库和远程参考的区别

``` sh
$  git log -p master.. origin/master
```
### 6. 把远程下载下来的代码合并到本地仓库，远程的和本地的合并

``` sh
$ git merge origin/master
```

出处：http://www.ymq.io
转自：鹏磊