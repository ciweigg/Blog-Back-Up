title: hexo next主题点击侧栏头像回到博客首页
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-31 13:39:00
---
>不知道为什么，我看到侧栏头像的第一反应是点击，然后心理预期会跳到博客首页
>但是默认主题是不能跳转的呀
>所以找了篇文章记录下
<!--more-->

文件位置：~/blog/themes/next/layout/_macro/sidebar.swig
```
+        <a href="/" class="site-author-image" rel="start" style="border:none">
          <img class="site-author-image" itemprop="image"
               src="{{ url_for( theme.avatar | default(theme.images + '/avatar.gif') ) }}"
               alt="{{ theme.author }}" />
+        </a>
```