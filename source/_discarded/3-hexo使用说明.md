title: 3-hexo使用说明
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-26 17:23:00
---
>下面如果没有特殊说明， `_config.yml` 都指主题配置文件，即 `3-hexo` 目录下

## 自定义首页
可查看这篇文章： {% post_link 3-hexo配置首页  %}

## blog快捷键
可查看这篇文章： {% post_link 3-hexo快捷键说明 %}

## 更换头像
两种方式：
1. 替换 `source/img/avatar.jpg` 图片。
2. 修改 `_config.yml` 中头像的配置记录

```xml
# 你的头像url
avatar: /img/avatar.jpg
favicon: /img/avatar.jpg
```

## 设置链接图标
如下，如果没有连接，则不展示图标。
```xml
#链接图标，链接为空则不显示
link:
  rss: /atom.xml
  github: https://github.com/yelog
  facebook: https://www.facebook.com/faker.tops
  twitter:
  linkedin:
  instagram:
  reddit: https://www.reddit.com/user/yelog/
  weibo: http://weibo.com/u/2307534817
  email: jaytp@qq.com
```

## 配置评论系统
目前添加了三种评论系统 **disqus、多说、网易云跟帖**
>`日志：` 2017-03-21：多说将于2017-06-01正式关停服务

### 启用评论
以 `disqus` 为例；
1. 关掉其他两个评论（设置on: false）
2. 启用 `disqus` ,设置on: true
3. 登陆 `disqus` 注册，得到shortname，填入shortname。
4. 重启 `hexo`。

### meta区显示评论数
开启设置 `_config.yml`
```xml
comment_count: true
# 文章标题下方显示评论数
```
![开启效果](http://oncj6b2vl.bkt.clouddn.com/FlDHXpVnJ-ECFCehRBoKkQMlqj_R.png)

### 评论区预加载
开启设置 `_config.yml`
```xml
preload_comment: false
```
1. false: 当点击评论条等区域时再加载评论模块
2. true: 页面加载时加载评论区
![关闭效果](http://oncj6b2vl.bkt.clouddn.com/FrYn2xsPMLBizQZ_p_mCa-hJYTG_.png)

## 样式设置
### 代码高亮
首先要关闭hexo根目录下`_config.yml`中的高亮设置：
```xml
highlight:
  enable: false
```
配置主题下`_config.yml`中的高亮设置：
可以根据提示，配置喜欢的高亮主题
```xml
highlight:
  on: true # true开启代码高亮
  lineNum: true # true显示行号
  theme: darcula
# 代码高亮主题,效果可以查看 https://highlightjs.org/static/demo/
# 支持主题：
# sublime : 参考sublime的高亮主题
# darcula : 参考idea中的darcula的主题
# atom-dark : 参考Atom的dark主题
# atom-light : 参考Atom的light主题
# github : 参考GitHub版的高亮主题
# github-gist : GitHub-Gist主题
# brown-paper : 牛皮纸效果
# gruvbox-light : gruvbox的light主题
# gruvbox-dark ： gruvbox的dark主题
# rainbow :
# railscasts :
# sunburst :
# kimbie-dark :
# kimbie-light :
# school-book : 纸张效果
```
### 表格样式
目前提供了3中样式，修改 `_config.yml`
```xml
table: green_title
# table 的样式
# 为空时类似github的table样式
# green 绿色样式
# green_title 头部为青色的table样式
```
### 文章列表的hover样式
鼠标移入的背景色和文字颜色变动，设置 `_config.yml`
```xml
#文章列表 鼠标移上去的样式, 为空时使用默认效果
article_list:
  hover:
    background: '#e2e0e0'  # 背景色:提供几种：'#c1bfc1'  '#fbf4a8'
    color:     # 文字颜色 提供几种：'#ffffff'
# 注意：由于颜色如果包含#，使用单引号 ' 引起来
```
## 开启字数统计
1. 开启此功能需先安装插件，在 hexo根目录 执行 `npm i hexo-wordcount --save`
2. 修改 `_config.yml`

```xml
word_count: true
```
## 多作者模式
可查看这篇文章： {% post_link 3-hexo多作者模式  %}

## 文章排序及置顶
可查看这篇文章： {% post_link Hexo置顶及排序问题  %}

## 关于写文章
### 如何写
每篇文章最好写上文集和标签，方便筛选和查看。
一般推荐一篇文章设置一个文集，一个或多个标签
`categories`:文集，为左侧列表
`tags`:标签，通过#来筛选
例如 本篇文章的设置
```xml
---
title: 3-hexo使用说明
date: 2017-03-23 15:13:47
categories:
- 工具
tags:
- hexo
- 3-hexo
---
```
### 写作技巧
1.设置模板，blog根目录 `scaffolds/post.md`
加入categories,tags等，这样以后通过 `hexo new` 生成的模板就不用写这两个单词了。
当然，你也可以写入任何你每个文章中都会有的部分。
```xml
---
title: {{ title }}
date: {{ date }}
categories:
tags:
---
```
2.设置脚本命令
其实就通过alias，触发一些命令的集合
在 `~/.bashrc` 文件中添加
```bash
alias hs='hexo clean && hexo g && hexo s'  #启动本地服务
alias hd='hexo clean && hexo g && hexo d'  #部署博客
```
甚至你也可以加入备份文章的命令，可以自由发挥。