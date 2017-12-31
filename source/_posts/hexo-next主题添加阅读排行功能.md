title: hexo next主题添加阅读排行功能
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-31 16:03:00
---
博客已有的分类，如 categories 和 tags，都是基于博主的，那么有没有一种分类是基于读者的呢？有，一种是搜索，另一种就是这里的文章阅读量排行榜。
<!--more-->
基于 leancloud_visitors的，需要申请账号

```
所在目录：~/blog/
hexo new page "top"
```

然后在主题配置文件中加上菜单 top 和它的 icon：

文件位置：~/blog/themes/next/_config.yml
```
menu:
  top: /top/
menu_icons:
  top: signal 
```
接着在语言翻译文件中加上菜单 top：

注意：如果你的站点配置文件中的 languages 写的不是 zh-Hans，那么这里请更改相应语言配置文件。

```
文件位置：~/blog/themes/next/languages/zh_Hans.yml
menu:
  home: 首页
  archives: 归档
  categories: 分类
  tags: 标签
  about: 关于
  search: 搜索
  top: 排行 /* 可以不为 排行，随便取 */
最后，编辑第一步新建页面生成的文件：
```

```
文件位置：~/blog/source/top/index.md
---
title: TopX /* 可以不为 TopX，随便取 */
comments: false
keywords: top,文章阅读量排行榜
---
<div id="top"></div>
<script src="https://cdn1.lncld.net/static/js/av-core-mini-0.6.4.js"></script>
<script>AV.initialize("app_id", "app_key");</script>
<script type="text/javascript">
  var time=0
  var title=""
  var url=""
  var query = new AV.Query('Counter');
  query.notEqualTo('id',0);
  query.descending('time');
  query.limit(1000);
  query.find().then(function (todo) {
    for (var i=0;i<1000;i++){
      var result=todo[i].attributes;
      time=result.time;
      title=result.title;
      url=result.url;
      var content="<a href='"+"https://reuixiy.github.io"+url+"'>"+title+"</a>"+"<br />"+"<font color='#555'>"+"阅读次数："+time+"</font>"+"<br /><br />";
      document.getElementById("top").innerHTML+=content
    }
  }, function (error) {
    console.log("error");
  });
</script>
```
必须将里面的里面的app_id和app_key替换为你的主题配置文件中的值，必须替换里面博客的链接，1000是显示文章的数量，其它可以自己看情况更改。

最后修改样式，这个可以根据自己风格修改：
```
文件位置：~/blog/themes/next/source/css/_custom/custom.styl
// 自定义的TopX页面样式
#top {
    display: block;
    text-align: center;
    margin: -100px 50px 40px 50px;
    box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.5);
    background-color: rgb(255, 255, 255);
    padding: 106px 36px 10px 36px;
}
@media (max-width: 767px) {
    #top {
        margin: -93px 15px 50px 15px;
        padding: 96px 10px 0px 10px;
    }
}
```

