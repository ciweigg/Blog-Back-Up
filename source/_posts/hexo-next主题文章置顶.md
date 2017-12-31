title: hexo next主题文章置顶
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-31 14:32:00
---
### 文章置顶

一篇博客如果自己觉得很有价值，那肯定要放在首页啦，所以产生了置顶功能
<!--more-->

#### 首先移除默认安装的插件：

所在目录：~/blog/
```
npm uninstall hexo-generator-index --save
```

然后安装新插件：
#### 所在目录：~/blog/
```
npm install hexo-generator-index-pin-top --save
```

这是这样修改好了在文章中添加置顶是不会有任何图标显示置顶的

所以我们用系统默认的图标来操作：

文件位置：~/blog/node_modules/hexo-generator-index-pin-top/lib/generator.js

```
'use strict';
var pagination = require('hexo-pagination');
module.exports = function(locals){
  var config = this.config;
  var posts = locals.posts;
    posts.data = posts.data.sort(function(a, b) {
        if(a.sticky && b.sticky) { // 两篇文章sticky都有定义
            if(a.sticky == b.sticky) return b.date - a.date; // 若sticky值一样则按照文章日期降序排
            else return b.sticky - a.sticky; // 否则按照sticky值降序排
        }
        else if(a.sticky && !b.sticky) { // 以下是只有一篇文章sticky有定义，那么将有sticky的排在前面（这里用异或操作居然不行233）
            return -1;
        }
        else if(!a.sticky && b.sticky) {
            return 1;
        }
        else return b.date - a.date; // 都没定义按照文章日期降序排
    });
  var paginationDir = config.pagination_dir || 'page';
  return pagination('', posts, {
    perPage: config.index_generator.per_page,
    layout: ['index', 'archive'],
    format: paginationDir + '/%d/',
    data: {
      __index: true
    }
  });
};
```
也就是将插件的top全部替换为 NexT 原有的sticky，然后将Front-matter中的top替换为sticky，就能调用 NexT 主题原有的置顶样式了
最后可以自定义一下样式：
```
文件位置：~/blog/themes/next/source/css/_custom/custom.styl
// 自定义的文章置顶样式
.post-sticky-flag {
    font-size: inherit;
    float: left;
    color: rgb(0, 0, 0);
    cursor: help;
    transition-duration: 0.2s;
    transition-timing-function: ease-in-out;
    transition-delay: 0s;
}
.post-sticky-flag:hover {
    color: #f935ea;
}
```

### 使用：
在需要置顶的文章中添加：
sticky: true
多文章需要置顶的话：
sticky: 1
sticky: 2
大的数值排在前面