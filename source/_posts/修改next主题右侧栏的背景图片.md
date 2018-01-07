title: 修改next主题右侧栏的背景图片
date: 2018-01-06 19:37:31
tags: [hexo]
categories: [hexo]
---
右侧栏都是黑色的看腻了啦
那么我们就换一套风格看看，哈哈
<!--more-->

### 修改背景图片
vi themes/next/source/css/_custom/custom.styl

```
#sidebar {
    position: fixed;
    right: 0;
    top: 0;
    bottom: 0;
    width: 0;
    z-index: 1040;
    box-shadow: inset 2px 2px 40px #35644a;
    background: #f5f5f5;
    background: url(http://oisa91ton.bkt.clouddn.com/sidebar.png);
    -webkit-transform: translateZ(0);
}
.site-author-name {
    margin: 5px 0 0;
    text-align: center;
    color: #35644a;
    font-weight: normal;
}
```

### 修改a链接的字体颜色
注释掉以前的
```
  a {
    // color: $grey-dark;
    color: #63b1b5;
    border-bottom-color: $black-light;
    &:hover { color: $gainsboro; }
  }
```