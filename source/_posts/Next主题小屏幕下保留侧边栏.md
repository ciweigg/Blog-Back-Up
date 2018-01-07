title: Next主题小屏幕下保留侧边栏
date: 2018-01-05 22:03:49
tags: [hexo]
categories: [hexo]
---
当然，iissnan最初决定在小屏幕上block掉侧栏是有原因的，这个副作用在这番改动之后也依然存在：极端尺寸设备上会出现侧栏完全覆盖主体甚至显示不全。改动的好处也很明显，页面内容展示更完全。毕竟H5普及之后，小型网站越来越不需要考虑兼容性问题，权衡利弊，这样做还是有意义的。
<!--more-->
恢复侧栏开关(适用于手机)

这一步参考上面提到的那篇教程。

### 启用侧边栏有两种方法：

#### 1.针对next主题：
默认已经实现了，改成true就行
themes/next/_config.yml
```
# Enable sidebar on narrow view (only for Muse | Mist).
onmobile: true
```

#### 2.针对其他主题
打开source/css/_common/components/sidebar/sidebar.styl，删掉或注释掉

```
/*+tablet() {
    display: none !important;
}
+mobile() {
  display: none !important;
}*/
```
启用按钮
首先是侧边栏开关，打开source/css/_common/components/sidebar/sidebar-toggle.styl，在.sidebar-toggle下修改

注释掉里面多余的代码留下和下面一样的代码
```
+tablet() {
  right: 20px;
  opacity: 0.8;
}
+mobile() {
  right: 20px;
  opacity: 0.8;
}
```
这里在解除隐藏的同时微调了显示效果。
然后是back-to-top按钮，类似的，打开source/css/_common/components/back-to-top.styl，在.back-to-top下修改

注释掉里面多余的代码留下和下面一样的代码
```
+tablet() {
  right: 20px;
  opacity: 0.8;
}
+mobile() {
  right: 20px;
  opacity: 0.8;
}
```
到这里已经实现了目标，但触摸屏上关闭侧边栏最方便的还是点击外围区域或者滑动，这里选择前一种实现方式。

增加关闭侧栏的方式
策略很简单，增加一个覆盖层与侧栏联动，点击覆盖层触发侧栏开关按钮的点击事件。首先修改layout/_macro/sidebar.swig，增加sidebar-dimmer层

```
<aside id="sidebar" class="sidebar">
  + <div id="sidebar-dimmer"></div>
  + <div class="sidebar-inner">
```
定义sidebar-dimmer的样式，这里我把代码放在source/css/_common/components/sidebar/sidebar-toggle.styl中

```
.sidebar-active #sidebar-dimmer {
  opacity: .7;
  -webkit-transform: translateX(-150%);
  transform: translateX(-150%);
  transition: opacity .2s;
}
#sidebar-dimmer {
  display: none;
  position: absolute;
  top: 0;
  left: 100%;
  width: 200%;
  height: 100%;
  background: #000;
  opacity: 0;
  transition: opacity .2s,transform 0s .2s;
  +mobile() {
    display: block;
  }
}
```
dimmer宽度倍率x和左移倍率y需要满足y=1+1/x的关系才能在侧栏展开时与dimmer右边界形成良好的衔接，所以需要根据mobile view最大宽度调整x的值。这里图省事把x设定为200%，y自然是150%了。
最后添加触发条件，修改source/js/src/motion.js
对比代码是否一样就行了，可能主题里添加过了

```
var sidebarToggleMotion = {
  toggleEl: $('.sidebar-toggle'),
  dimmerEl: $('#sidebar-dimmer'),  //init
  sidebarEl: $('.sidebar'),
  isSidebarVisible: false,
  init: function () {
    this.toggleEl.on('click', this.clickHandler.bind(this));
    this.dimmerEl.on('click', this.clickHandler.bind(this));   //binding
    this.toggleEl.on('mouseenter', this.mouseEnterHandler.bind(this));
    this.toggleEl.on('mouseleave', this.mouseLeaveHandler.bind(this));
```    