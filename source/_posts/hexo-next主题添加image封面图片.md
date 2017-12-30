title: hexo next主题添加image封面图片
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-30 20:35:00
---
主要实现的就是在标题和摘要中间，插进一张Logo图片，而当点击进入后，就不会再显示这个logo图片了。原文地址：Hexo主题的数据封装，样式渲染和扩展实例。
<!--more-->
### css样式
> hexo/themes/next/source/css/: 是next主题的样式文件，决定主题的外观。
> hexo/themes/next/source/css/main.styl：汇总css文件夹中所有的样式。
> hexo/themes/next/source/css/_custom/custom.styl：是空的，专门让开发者扩展。

### 修改：/blog/themes/next/layout/_macro/post.swig
添加：
//图片外部的容器方框 
.out-img-topic {
  display: block;
  max-height:300px;
  margin-bottom: 24px;
  overflow: hidden;
}
//图片
img.img-topic {
  display: block ;
  margin-left: .7em;
  margin-right: .7em;
  padding: 0;
  float: right;
  clear: right;
}

这里图片外部的容器用来限制图片显示的大小，最大的高度为300px，overflow: hidden;让多余部分隐藏。margin-bottom: 24px;确保图片和文章摘要部分空出一定空间。

### 渲染
修改 /themes/next/layout/_macro/post.swig ，在 if is_index 与 if post.description and theme.excerpt_description 之间添加以下代码

```
      {% if is_index %}
        {% if post.description and theme.excerpt_description %}
          {{ post.description }}
          <!--noindex-->
          <div class="post-button text-center">
            <a class="btn" href="{{ url_for(post.path) }}">
              {{ __('post.read_more') }} &raquo;
            </a>
          </div>
          <!--/noindex-->
        {% elif post.excerpt  %}
          {{ post.excerpt }}
+          
+        {% if post.image %}
+        <div class="out-img-topic">
+          <img src={{ post.image }} class="img-topic" />
+        </div>
+        {% endif %}
+          
          <!--noindex-->
          <div class="post-button text-center">
            <a class="btn" href="{{ url_for(post.path) }}{% if theme.scroll_to_more %}#{{ __('post.more') }}{% endif %}" rel="contents">
              {{ __('post.read_more') }} &raquo;
            </a>
          </div>
          <!--/noindex-->
```
每次写文章的时候 xxx.md 中头部添加
image: url

他不能与：description一起添加，所以失效的