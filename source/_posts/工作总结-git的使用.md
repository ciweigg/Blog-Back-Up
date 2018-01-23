title: 工作总结-git的使用
date: 2018-01-23 13:47:35
tags: [Git]
categories: [Git]
---
## 关联本地和远程仓库
### 1. 安装git
先安装homebrew，然后通过homebrew安装git

git中clone项目有两种方式：https和ssh
```
https：不管是谁，拿到url随便clone，但是在push的时候需要验证用户名和密码
ssh：clone项目你必须是拥有者或者管理员，而且需要在clone前添加SSH Key。
     SSH在push的时候，是不需要输入用户名的，如果配置SSH Key的时候设置了密码，
     则需要输入密码，否则是不需要输入密码的
```
<!--more-->
git中使用SSH Key的步骤：

```
1.检查电脑是否存在SSH Key
cd ~/.ssh
ls
如果存在id_rsa.pub或id_dsa.pub文件，说明文件已经存在，跳过创建SSH Key步骤
2.创建SSH Key
ssh -keygen -t rasa -C “your_email@example.com”
3.查看SSH Key
cat ~/.ssh/id_rsa.pub
4.将查看的SSH Key赋值到git中设置好
5.测试SSH Key
ssh -T git@git.oschina.net 
出现Welcome to xxx就可以了
```

### 2. 新建本地仓库
```
mkdir learn-git
cd learn-git
git init // 初始化仓库
```

### 3.推送到远程仓库
在github上新建一个空的仓库，默认设置
github告诉我们可以从这个仓库克隆出新的仓库，也可以把已有的本地仓库与之关联，然后把本地仓库的内容推送到github仓库上

```
git remote add origin <server>  // 将本地仓库连接到某个远程服务器
git push origin master // 推送本地仓库到远程某个分支上
git remote remove origin // 取消本地目录下关联的远程仓库
```
在执行如下操作会遇到点小问题

```
git remote add origin https://github.com/Liuhui11/learn-git.git
git push -u origin master 报错error: src refspec master does not match any.
```
这样是因为：空仓库不能提交上去（给项目添加文件），执行如下命令即可解决

```
touch README // 创建新文件
git commit -m ‘first commit’
git push -u origin master // 第一推送需要加-u选项
```

### 分支管理
```
git branch dev // 创建分支 
git branch // 查看分支
git checkout dev // 切换分支
git merge dev // 合并指定分支到当前分支
 git push origin dev:master // 提交本地分支到远程
git branch -d dev // 删除分支
```
#### 1. 分支管理策略
```
master分支：稳定、仅用来发布新版本，平时不能在上面干活
dev分支：不稳定、干活的地方，发布新版本时合并到master上
个人开发的分支：每个人都有自己的分支，最终要往dev上合并

合并分支时加上—no-ff参数可使用普通模式合并，合并后的历史有分支，能看出来曾经做过合并；
而fast forward合并就看不出来曾经做过合并
```
#### 2. bug分支
但当前工作区任务还未完成又要改bug的时候使用

```
git stash 将当前工作现场储存起来，等以后恢复现场后继续工作
git stash apply 恢复之前的工作现场
git stash list
git stash drop 删除stash内容
it stash apply stash@{0} 恢复到指定的stash
```
#### 3. feature分支
为新功能创建分支
```
git branch -D feature-vulcan 强行删除分支
```
#### 4. 多人协作
```
git remote -v 查看远程库的信息
master分支是主分支，因此时刻与远程同步
dev分支是开发分支，团队所有成员都需要在上面工作，所以也需要与远程同步
bug分支只用于在本地修复bug，就没必要推到远程了
feature分支是否推到远程，取决于你是否和你的小伙伴在上面开发

git checkout -b dev origin/dev 关联远程dev分支到本地，即创建本地dev分支
git branch --set-upstream dev origin/dev dev和origin/dev的连接
```
### 工作模式：

```
1.试图用git push origin branch-name推送自己的修改
2.如果推送失败，则因为远程分支比你的本地更新，需要新用git pull试图合并
3.如果合并有冲突，则解决冲突，并在本地提交
4.没有冲突或者解决掉冲突后，再用git push origin branch-name推送就能成功

如果git pull提示“no tracking information”，则说明本地分支和远程分支的链接关系没有创建，
用命令git branch --set-upstream branch-name origin/branch-name
```

### 标签管理
```
git tag v1.0 // 创建标签，默认标签是打在最新提交的commit上的
git tag // 查看标签
git tag -a <tagname> -m "blablabla..." // 指定标签信息
git tag -s <tagname> -m "blablabla..." // 用PGP签名标签
```

找到历史提交的commit id打标签:
```
1.git log --pretty=oneline --abbrev-commit 
2.git tag v1.0 commi-id

git tag -d v1.0 // 删除标签
git push origin <tagname> // 推送指定标签
git push origin --tags // 一次性推送全部尚未推送到远程的本地标签
git tag -d v0.9 & git push origin :refs/tags/v0.9 // 删除远程标签
```
### 代码管理
#### 1. 工作区与暂存区
```
工作区 work 
暂存区 index/stage
git rm file 删除暂存区或分支上的文件，同时工作区也不需要
git rm —cached file 保留了工作区的这个文件
```
#### 2. 管理修改
```
git比其他版本控制系统优秀的原因是git跟踪并管理的是修改，而非文件
```

#### 3.提交修改
```
git pull // 相当于是从远程获取最新版并merge到本地
git fetch // 相当于是从远程获取最新版本到本地，不会自动merge 
git fetch // 拉取分支
git diff dev // 比较分支修改
git merge dev // 合并分支
git log -p master ..origin/master // 比较本地和远程分支的差别
git pull // 相当于git fetch加git merge，实际过程中git fetch更安全一些，因为在merge前可以查看更新情况，然后决定是否合并
git branch --set-upstream-to=origin/dev 本地新建分支后必须要做远程分支关联，这样在pull、push的时候不需要指定远程的分支
git commit // 只负责把暂存区的修改提交了
git diff HEAD — app/user/user.html // 查看工作区和版本库里面最新版本的区别
git checkout — file // 丢弃工作区的修改
git rm file // 删除文件
git rm // 如果一个文件已经被提交到版本库，那么你永远不用担心误删，但是要小心你只能恢复文件到最新版本，你会丢失最近一次提交后你修改的内容
```

#### 代码回滚
```
git log／git log --pretty=oneline // 查看commit的历史记录
git reset —hard HEAD^ // 回退到上一个版本，或者通过commit id来回退到指定版本
git reflog // 记录你的每一次命令，包括未来的版本 找到之前版本的commit id可以返回到最新的版本
git checkout file // 此命令会使用HEAD中的最新内容替换掉你的工作目录中的文件，已添加到暂存区的改动以及新文件都不会受到影响。
git fetch origin & git reset —hard origin/master // 丢去你在本地的所有改动与提交，可以到服务器上获取最新的版本历史，并将你本地主分支指向它
```

#### 忽略文件
忽略文件的原则：
```
1. 忽略操作系统自动生成的文件，比如缩略图
2. 忽略编译生成的中间文件、可执行文件等，也就是如果一个文件是通过另一个文件自动生成的，那自动生成的文件就没必要放进版本库
3. 忽略你自己的带有敏感信息的配置文件，比如存放口令的配置文件

比如忽略所有js文件的规则：*.js
git add -f file 强制添加文件，即使被忽略了
git check-ignore -v file 查看文件不能被提交是哪个规则写的
https://github.com/github/gitignore 在线自动生成忽略文件
```
#### 练习：

```
忽略已经被追踪的文件
git rm --cached file
更新.gitignore忽略掉目标文件
git add .
git commit -m 
或者：git update-index --assume-unchanged logs/*.log
```

#### 参考资料：按难易程度排序
https://rogerdudler.github.io/git-guide/index.zh.html git - 简明指南
https://marklodato.github.io/visual-git-guide/index-zh-cn.html 图解git
https://try.github.io/levels/1/challenges/1 git在线练习
https://git-scm.com/book/zh/v2 git必看 git入门和进深
https://segmentfault.com/q/1010000000358588 github相关资料推荐
https://git-scm.com/docs/ git官方文档