title: next的自动更新背景图片实现方法及效果图展示
date: 2018-01-06 22:29:55
tags: [hexo]
categories: [hexo]
---
实现的原理
修改背景样式
修改themes/next/source/css/ _custom/custom.styl文件，这个是Next故意留给用户自己个性化定制一些样式的文件，添加以下代码：

```
body {
    background:url(https://source.unsplash.com/random/1600x900);
    background-repeat: no-repeat;
    background-attachment:fixed;
    background-position:50% 50%;
}
```
<!--more-->
如果自己不喜欢这个网址提供的图片做背景，那么修改url()里面的路径即可。repeat、attachment、position就是调整图片的位置，不重复出现、不滚动等等。

修改不透明度
完成这一步其实背景就会自动更换了，但是会出现一个问题，因为next主题的背景是纯透明的，这样子就造成背景图片的影响看不见文字，这对于博客来说肯定不行。

那么就需要调整背景的不透明度了。同样是修改themes/next/source/css/_custom/custom.styl文件。在后面添加如下代码
```
.main-inner { 
    margin-top: 60px;
    padding: 60px 60px 60px 60px;
    background: #fff;
    opacity: 0.8;
    min-height: 500px;
}
```
background: #fff; 白色 opacity: 0.8;不透明度