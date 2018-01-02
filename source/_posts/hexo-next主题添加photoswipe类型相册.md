title: hexo next主题添加photoswipe类型相册
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2018-01-02 17:12:00
---
next主题一定是要我github的next主题
<!--more-->
其实就是github上搜索hexo-theme-next这个人的next主题
![paste image](http://oisa91ton.bkt.clouddn.com/1514884431453sqwkgwdz.png?imageslim)

首先下载我的博客备份：
shell文件夹中的tool.py就是我们需要的生成照片脚本了 
```
执行：python tool.py
照片格式：2017-01-02_名称.jpg
上传照片存储在脚本的photos
会生成缩略图存储在min_photos
```
他会将生成的照片放在/blog/source/photos/文件中data.json
那么当然了photos文件夹中的文件也就是照片需要的page页面了
修改成自己的github备份仓库能访问到图片的地址就行：
文件位置(blog根目录)：
```
blog/source/photos/ins.js
```
![paste image](http://oisa91ton.bkt.clouddn.com/1514884819115xldu0nf6.png?imageslim)

hexo g
hexo s
访问photos就能看到相册了，菜单配置就不说了
![paste image](http://oisa91ton.bkt.clouddn.com/151488514435550agul4q.png?imageslim)
