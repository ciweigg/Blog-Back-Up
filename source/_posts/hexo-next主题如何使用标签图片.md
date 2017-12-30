title: hexo next主题如何使用标签图片
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-30 17:36:00
---
## 新建一篇文章 xxx.md
然后按照如下格式编辑
主要是type: picture
<!-- more -->
![paste image](http://oisa91ton.bkt.clouddn.com/1514626799446n8r7bw4x.png?imageslim)

5-3 是一种显示的模式 排版 这个可以选择的样式很多
9-6也不错的
例子参考在：
图片展示效果
{\% gp 5-3 \%}：设置图片展示效果，参考 themes/next/scripts/tags/group-pictures.js 注释示意图
5-3 的意思就是5张图片将会按照这种布局来展示，Next 提供了多张图片的多种布局，你可以随意选择

```
categories:
  - picture
tags:
  - picture
type: picture
date: 2017-07-30 14:36:00
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

{% gp 5-3 %}
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy1.jpg)
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy2.jpg)
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy3.jpg)
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy4.jpg)
![](http://oisa91ton.bkt.clouddn.com/2017-08-01_chinajoy5.jpg)
{% endgp %}

### 注意点
主题目前首页可以正常显示设置的图片效果，但是点击进入后显示效果丢失，所以需要修改一下文件 themes/next/source/css/_common/components/tags/group-pictures.styl 中的以下样式：

```
.page-post-detail .post-body .group-picture-column {
  // float: none;
  margin-top: 10px;
  // width: auto !important;
  img { margin: 0 auto; }
}
```