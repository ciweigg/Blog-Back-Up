title: hexo next主题特殊功能
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2018-01-01 18:29:00
---
### 1.画廊效果
```
layout: photo
title: 画廊
date: 2017-01-16 02:03:32
tags: hexo
photos:
 - http://xxx.jpg
 - http://xxx.jpg
```
<!--more-->
### 2.标签图片
```
title: 标签图片
categories:
  - picture
tags:
  - picture
type: picture
date: 2017-07-30 14:32:00
---
动漫图片：
{% gp 5-3 %}
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy1.jpg)
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy2.jpg)
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy3.jpg)
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy4.jpg)
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy5.jpg)
{% endgp %}
```