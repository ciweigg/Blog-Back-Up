title: hexo next主题修改标签云颜色
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-31 14:48:00
---
![paste image](http://oisa91ton.bkt.clouddn.com/151470296257694j6rjuk.png?imageslim)
<!--more-->
更改标签云（tagcloud）的颜色
修改：
```
文件位置：~/blog/themes/next/layout/page.swig
{{ tagcloud({min_font: 13, max_font: 31, amount: 1000, color: true, start_color: '#9733EE', end_color: '#87daff'}) }}
```