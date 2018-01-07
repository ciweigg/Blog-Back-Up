title: 为Hexo-Next主题设置头部图片
date: 2018-01-06 21:56:06
tags: [hexo]
categories: [hexo]
---
 vi themes/next/source/css/_common/components/header/header.styl 
// 下面的url()里不一定非要填相对路径，填一个能访问的url即可，比如放在七牛云上的图片
.header { background: url('../image/background.jpg'); }
<!--more-->