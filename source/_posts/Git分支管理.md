title: Git分支管理
author: John Doe
tags:
  - git
categories:
  - Git
date: 2017-12-15 11:54:00
---
分支在实际中有什么用呢？假设你准备开发一个新功能，但是需要两周才能完成，第一周你写了50%的代码，如果立刻提交，由于代码还没写完，不完整的代码库会导致别人不能干活了。如果等代码全部写完再一次提交，又存在丢失每天进度的巨大风险。

分支的独立性：现在有了分支，就不用怕了。你创建了一个属于你自己的分支，别人看不到，还继续在原来的分支上正常工作，而你在自己的分支上干活，想提交就提交，直到开发完毕后，再一次性合并到原来的分支上，这样，既安全，又不影响别人工作。
<!-- more -->
git分支的高效：其他版本控制系统如SVN等都有分支管理，但是用过之后你会发现，这些版本控制系统创建和切换分支比蜗牛还慢，简直让人无法忍受，结果分支功能成了摆设，大家都不去用。

但Git的分支是与众不同的，无论创建、切换和删除分支，Git在1秒钟之内就能完成！无论你的版本库是1个文件还是1万个文件。

理解HEAD头指针

一开始的时候，HEAD头指针指向的是主分支，即master分支。而HEAD指向的是当前分支，master指向的是提交。

如果，在master分支上新建了一个分支dev，此时HEAD指向了dev，Git建立分支的过程很快，因为除了增加一个dev指针，改改HEAD的指向，工作区的文件都没有任何变化！

不过，从现在开始，对工作区的修改和提交就是针对dev分支了，比如新提交一次后，dev指针往前移动一步，而master指针不变。

创建dev分支

创建分支使用git branch命令，命令格式：git branch [分支别名]

$ git branch dev
可以使用$ git branch来查看所有本地分支，$ git branch -a查看所有分支（包括远程分支）。

使用git checkout [分支名]切换到对应的分支，如：

$ git checkout dev 
此时，HEAD头指针会指向dev，如果在dev上提交，dev指针会往前移，而其他分支不变。（master分支及指针不变）

当使用git checkout master时，HEAD头指针会重新指向master，此时再提交，master指针会往前移。

这个过程，需要自己亲身的试验才能体会到它们的作用和变化。

$gitk
使用Git自带的图形界面，可以很好的来管理分支。

冲突解决

冲突产生：当两个分支中修改的相同的文件并提交（add->commit），合并(merge)这两个分支的时候，会产生冲突。

如下例：

$ git checkout -b feature1
在新的feature1分支下修改了readme.txt：

vi readme.txt
//修改，添加Creating a new branch is quick AND simple.
$ git add readme.txt 
$ git commit -m "AND simple"
切换到master分支：

$ git checkout master

vi readme.txt
//在`master`分支上把readme.txt文件的最后一行改为：Creating a new branch is quick & simple
$ git add readme.txt 
$ git commit -m "& simple"
试图合并master与feature1：

$ git merge feature1
Auto-merging readme.txt
CONFLICT (content): Merge conflict in readme.txt
Automatic merge failed; fix conflicts and then commit the result.

（1）使用：$ git status来查看冲突文件：

$ git status
# On branch master
# Your branch is ahead of 'origin/master' by 2 commits.
#
# Unmerged paths:
#   (use "git add/rm <file>..." as appropriate to mark resolution)
#
#       both modified:      readme.txt
#
no changes added to commit (use "git add" and/or "git commit -a")
（2）直接查看readme.txt文件内容：

Git is a distributed version control system.
Git is free software distributed under the GPL.
Git has a mutable index called stage.
Git tracks changes of files.
<<<<<<< HEAD
Creating a new branch is quick & simple.
=======
Creating a new branch is quick AND simple.
>>>>>>> feature1
Git用<<<<<<<，=======，>>>>>>>标记出不同分支的内容，我们修改如下后保存：

Creating a new branch is quick and simple.
再提交：

$ git add readme.txt 
$ git commit -m "conflict fixed"
[master 59bc1cb] conflict fixed
PS: 用带参数的git log也可以看到分支的合并情况：

$ git log --graph --pretty=oneline --abbrev-commit
*   59bc1cb conflict fixed
|\
| * 75a857c AND simple
* | 400b400 & simple
|/
* fec145a branch test
...
最后，删除feature1分支：

$ git branch -d feature1
Deleted branch feature1 (was 75a857c).

分支管理策略

通常，合并分支时，如果可能，Git会用Fast forward模式，但这种模式下，删除分支后，会丢掉分支信息。

如果要强制禁用Fast forward模式，Git就会在merge时生成一个新的commit，这样，从分支历史上就可以看出分支信息。

下面我们实战一下--no-ff方式的git merge：

首先，仍然创建并切换dev分支：

$ git checkout -b dev
Switched to a new branch 'dev'
修改readme.txt文件，并提交一个新的commit：

$ git add readme.txt 
$ git commit -m "add merge"
[dev 6224937] add merge
 1 file changed, 1 insertion(+)
现在，我们切换回master：

$ git checkout master
Switched to branch 'master
准备合并dev分支，请注意--no-ff参数，表示禁用Fast forward：

$ git merge --no-ff -m "merge with no-ff" dev
Merge made by the 'recursive' strategy.
 readme.txt |    1 +
 1 file changed, 1 insertion(+)
分支策略

在实际开发中，我们应该按照几个基本原则进行分支管理：

首先，master分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活；

那在哪干活呢？干活都在dev分支上，也就是说，dev分支是不稳定的，到某个时候，比如1.0版本发布时，再把dev分支合并到master上，在master分支发布1.0版本；

你和你的小伙伴们每个人都在dev分支上干活，每个人都有自己的分支，时不时地往dev分支上合并就可以了。

所以，团队合作的分支看起来就像这样：

Bug分支

软件开发中，bug就像家常便饭一样。有了bug就需要修复，在Git中，由于分支是如此的强大，所以，每个bug都可以通过一个新的临时分支来修复，修复后，合并分支，然后将临时分支删除。

当你接到一个修复一个代号101的bug的任务时，很自然地，你想创建一个分支issue-101来修复它，但是，等等，当前正在dev上进行的工作还没有提交：

$ git status
# On branch dev
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       new file:   hello.py
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#       modified:   readme.txt
#
并不是你不想提交，而是工作只进行到一半，还没法提交，预计完成还需1天时间。但是，必须在两个小时内修复该bug，怎么办？

幸好，Git还提供了一个stash功能，可以把当前工作现场“储藏”起来，等以后恢复现场后继续工作：

$ git stash
Saved working directory and index state WIP on dev: 6224937 add merge
HEAD is now at 6224937 add merge
现在，用git status查看工作区，就是干净的（除非有没有被Git管理的文件），因此可以放心地创建分支来修复bug。

首先确定要在哪个分支上修复bug，假定需要在master分支上修复，就从master创建临时分支：

$ git checkout master
$ git checkout -b issue-101
现在修复bug，需要把“Git is free software …”改为“Git is a free software …”，然后提交：

$ git add readme.txt 
$ git commit -m "fix bug 101"
修复完成后，切换到master分支，并完成合并，最后删除issue-101分支：

$ git checkout master
$ git merge --no-ff -m "merged bug fix 101" issue-101
$ git branch -d issue-101
太棒了，原计划两个小时的bug修复只花了5分钟！现在，是时候接着回到dev分支干活了！

$ git checkout dev
Switched to branch 'dev'
$ git status
# On branch dev
nothing to commit (working directory clean)
工作区是干净的，刚才的工作现场存到哪去了？用git stash list命令看看：

$ git stash list
stash@{0}: WIP on dev: 6224937 add merge
工作现场还在，Git把stash内容存在某个地方了，但是需要恢复一下，有两个办法：

一种方式：用git stash apply恢复，但是恢复后，stash内容并不删除，你需要用git stash drop来删除；

另一种方式：是用git stash pop，恢复的同时把stash内容也删了：

$ git stash pop
# On branch dev
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       new file:   hello.py
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#       modified:   readme.txt
#
Dropped refs/stash@{0} (f624f8e5f082f2df2bed8a4e09c12fd2943bdd40)
再用git stash list查看，就看不到任何stash内容了：

$ git stash list
你可以多次stash，恢复的时候，先用git stash list查看，然后恢复指定的stash，用命令：

$ git stash apply stash@{0}
删除分支

软件开发中，总有无穷无尽的新的功能要不断添加进来。

添加一个新功能时，你肯定不希望因为一些实验性质的代码，把主分支搞乱了，所以，每添加一个新功能，最好新建一个feature分支，在上面开发，完成后，合并，最后，删除该feature分支。

还记得吗？

建立新的分支:git checkout -b feature-new

工作提交：git add --a，git commit -m "something..."

回到dev开发分支：git checkout dev

合并分支：git merge --no-ff feature-new

一切顺利的话，feature分支和bug分支是类似的，合并，然后删除。

但是，就在此时，接到上级命令，因经费不足，新功能必须取消！虽然白干了，但是这个分支还是必须就地销毁：

（1）如果没有合并之前，可以简单的使用git branch -d [分支名]来删除分支（使用-D命令，强制删除分支）

（2）如果已经合并，除了上面的需要删除以外，还需要使用前面讲到的git reset --hard HEAD^来退回到上一个版本。

PS:分支的删除，不会影响到其他分支上已经合并的分支内容。

多人协作

多人协作的工作模式通常是这样：

首先，可以试图用git push origin branch-name推送自己的修改；

如果推送失败，则因为远程分支比你的本地更新，需要先用git pull试图合并；

如果合并有冲突，则解决冲突，并在本地提交；

没有冲突或者解决掉冲突后，再用git push origin branch-name推送就能成功！

如果git pull提示“no tracking information”，则说明本地分支和远程分支的链接关系没有创建，用命令git branch --set-upstream branch-name origin/branch-name。

这就是多人协作的工作模式，一旦熟悉了，就非常简单。

注：所有工作流建立在已经建立了个人账户，并添加了SSH key到个人的文档中。见Profile Settings → SSH keys → Before you can add an SSH key you need to [generate it].

普通开发人员

情况一：程序员A是后加入到项目中的，项目已经存在代码仓库。

如：git@github.com:kanlidy/HelloGit.git

（1）克隆版本仓库

git clone git@github.com:kanlidy/HelloGit.git
（2）建立分支

git checkout -b (分支名)
（3）提交代码

查看代码修改的状态：

git status 
添加到工作区：

git add .
提交到本地仓库：

git commit -m "（写下提交日志）"
推送到服务器：

git push origin 分支名
（4）在服务器上建立Merge Request，把自己的提交到远程的分支，Merge到Dev(开发分支)

情况二：程序员B是在一个新项目中，本地有一些代码，需要建立一个版本控制仓库

（1）在项目目录下，初始化仓库

git init
（2）添加到git版本控制系统：

git remote add origin git@github.com:kanlidy/HelloGit.git
（3）添加所有已经存在的文件到项目中：

git add .
（4）提交代码到本地仓库：

git commit -m "写下日志"
（5）提交代码远程服务器

git push origin <本地分支名>：<远程分支名>

git push origin master:master
对于单人项目，情况二足以满足代码控制要求。→吕扬、刘扬。

仓库管理人员

情况一：手工合并代码

（1）在指定分支上获取更新

git checkout <指定分支>
（2）拉取服务器上的代码

git pull origin <指定分支>
（3）切换到dev，并获取dev上的更新，合并指定分支上的代码

git checkout dev
git pull origin dev
git merge <指定分支>
情况二：直接在gitlab上进行操作

直接点击accept merge request进行分支合并。

代码回撤参考git reset命令，获取更新参考git fetch命令，分支查看git branch，逻辑流程图gitk，状态命令git status,日志命令git reflog与git log
