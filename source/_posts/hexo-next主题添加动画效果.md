title: hexo next主题添加动画效果
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-30 18:19:00
---
### 1. 添加High一下
打开博客根目录 /themes/next/layout/_partials/header.swig ，在
ul标签之间加入以下代码：
<!-- more -->
```
<li> <a title="把这个链接拖到你的Chrome收藏夹工具栏中" href='javascript:(function() {
    function c() {
        var e = document.createElement("link");
        e.setAttribute("type", "text/css");
        e.setAttribute("rel", "stylesheet");
        e.setAttribute("href", f);
        e.setAttribute("class", l);
        document.body.appendChild(e)
    }
    function h() {
        var e = document.getElementsByClassName(l);
        for (var t = 0; t < e.length; t++) {
            document.body.removeChild(e[t])
        }
    }
    function p() {
        var e = document.createElement("div");
        e.setAttribute("class", a);
        document.body.appendChild(e);
        setTimeout(function() {
            document.body.removeChild(e)
        }, 100)
    }
    function d(e) {
        return {
            height : e.offsetHeight,
            width : e.offsetWidth
        }
    }
    function v(i) {
        var s = d(i);
        return s.height > e && s.height < n && s.width > t && s.width < r
    }
    function m(e) {
        var t = e;
        var n = 0;
        while (!!t) {
            n += t.offsetTop;
            t = t.offsetParent
        }
        return n
    }
    function g() {
        var e = document.documentElement;
        if (!!window.innerWidth) {
            return window.innerHeight
        } else if (e && !isNaN(e.clientHeight)) {
            return e.clientHeight
        }
        return 0
    }
    function y() {
        if (window.pageYOffset) {
            return window.pageYOffset
        }
        return Math.max(document.documentElement.scrollTop, document.body.scrollTop)
    }
    function E(e) {
        var t = m(e);
        return t >= w && t <= b + w
    }
    function S() {
        var e = document.createElement("audio");
        e.setAttribute("class", l);
        e.src = i;
        e.loop = false;
        e.addEventListener("canplay", function() {
            setTimeout(function() {
                x(k)
            }, 500);
            setTimeout(function() {
                N();
                p();
                for (var e = 0; e < O.length; e++) {
                    T(O[e])
                }
            }, 15500)
        }, true);
        e.addEventListener("ended", function() {
            N();
            h()
        }, true);
        e.innerHTML = " <p>If you are reading this, it is because your browser does not support the audio element. We recommend that you get a new browser.</p> <p>";
        document.body.appendChild(e);
        e.play()
    }
    function x(e) {
        e.className += " " + s + " " + o
    }
    function T(e) {
        e.className += " " + s + " " + u[Math.floor(Math.random() * u.length)]
    }
    function N() {
        var e = document.getElementsByClassName(s);
        var t = new RegExp("\\b" + s + "\\b");
        for (var n = 0; n < e.length; ) {
            e[n].className = e[n].className.replace(t, "")
        }
    }
    var e = 30;
    var t = 30;
    var n = 350;
    var r = 350;
    var i = "//7xuupy.com1.z0.glb.clouddn.com/tongxingSibel%20-%20Im%20Sorry.mp3";
    var s = "mw-harlem_shake_me";
    var o = "im_first";
    var u = ["im_drunk", "im_baked", "im_trippin", "im_blown"];
    var a = "mw-strobe_light";
    var f = "//s3.amazonaws.com/moovweb-marketing/playground/harlem-shake-style.css";
    var l = "mw_added_css";
    var b = g();
    var w = y();
    var C = document.getElementsByTagName("*");
    var k = null;
    for (var L = 0; L < C.length; L++) {
        var A = C[L];
        if (v(A)) {
            if (E(A)) {
                k = A;
                break
            }
        }
    }
    if (A === null) {
        console.warn("Could not find a node of the right size. Please try a different page.");
        return
    }
    c();
    S();
    var O = [];
    for (var L = 0; L < C.length; L++) {
        var A = C[L];
        if (v(A)) {
            O.push(A)
        }
    }
    })()    '>High一下</a> </li>
    ```
    
### 2. 鼠标点击小红心的设置
1. 将 love.js 文件添加到 /themes/next/source/js/src 文件目录下。
2. 找到 /themes/next/layout/_layout.swing 文件， 在文件的后面，</body> 标签之前 添加以下代码：
```
<!-- 页面点击小红心 -->
<script type="text/javascript" src="/js/src/love.js"></script>
```
### 3. 背景的设置
1.将 particle.js 文件添加到 /themes/next/source/js/src 文件目录下。
2.找到 /themes/next/layout/_layout.swing 文件， 在文件的后面，</body>标签之前 添加以下代码：
```
<!-- 背景动画 -->
<script type="text/javascript" src="/js/src/particle.js"></script>

```