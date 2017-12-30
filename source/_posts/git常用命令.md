title: git常用命令
author: John Doe
tags: []
categories:
  - Git
date: 2017-12-16 12:04:00
---
![“git”](http://oisa91ton.bkt.clouddn.com/20171216120142.png) 

<!-- more -->

### git 流程
git status
git add .
git commit
git pull
git push origin branchName:refs/for/branchName
git pull

### create branch
git checkout -b featureOne
git push —set-upstream origin featureOne
git add .
git commit -m ‘msg’
git pull
git push origin featureOne:refs/for/featureOne
git pull

### merge to master
git checkout master
git merge featureOne
git add .
git commit -m ‘merge’
git pull
git push origin master:refs/for/master
git pull

done
