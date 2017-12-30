title: hexo next主题添加博客运行时间
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-30 22:02:00
---
### 侧栏加入已运行的时间
记录一下博客创建的时间，和一共用了多久呀，写博客需要坚持的 23333333333333333333
<!--more-->
首先要加入下面代码：
文件位置：~/blog/themes/next/layout/_custom/sidebar.swig
初始化的时候这个文件是空的哦
```
<div id="days"></div>
</script>
<script language="javascript">
function show_date_time(){
window.setTimeout("show_date_time()", 1000);
BirthDay=new Date("05/20/2017 15:00:00");
today=new Date();
timeold=(today.getTime()-BirthDay.getTime());
sectimeold=timeold/1000
secondsold=Math.floor(sectimeold);
msPerDay=24*60*60*1000
e_daysold=timeold/msPerDay
daysold=Math.floor(e_daysold);
e_hrsold=(e_daysold-daysold)*24;
hrsold=setzero(Math.floor(e_hrsold));
e_minsold=(e_hrsold-hrsold)*60;
minsold=setzero(Math.floor((e_hrsold-hrsold)*60));
seconds=setzero(Math.floor((e_minsold-minsold)*60));
document.getElementById('days').innerHTML="已运行"+daysold+"天"+hrsold+"小时"+minsold+"分"+seconds+"秒";
}
function setzero(i){
if (i<10)
{i="0" + i};
return i;
}
show_date_time();
</script>
```
上面BirthDay的值记得改为你自己的，且按上面格式，然后修改：
文件位置：~/blog/themes/next/layout/_macro/sidebar.swig
+号是需要添加的位置，-号是需要注释掉的 <!-- -->
```
        {# Blogroll #}
        {% if theme.links %}
          <div class="links-of-blogroll motion-element {{ "links-of-blogroll-" + theme.links_layout | default('inline') }}">
            <div class="links-of-blogroll-title">
              <i class="fa  fa-fw fa-{{ theme.links_icon | default('globe') | lower }}"></i>
              {{ theme.links_title }}&nbsp;
              <i class="fa  fa-fw fa-{{ theme.links_icon | default('globe') | lower }}"></i>
            </div>
            <ul class="links-of-blogroll-list">
              {% for name, link in theme.links %}
                <li class="links-of-blogroll-item">
                  <a href="{{ link }}" title="{{ name }}" target="_blank">{{ name }}</a>
                </li>
              {% endfor %}
            </ul>
+        {% include '../_custom/sidebar.swig' %}
          </div>
         {% endif %}
-        {% include '../_custom/sidebar.swig' %}
```
这样就可以了！当然，要是不喜欢颜色，感觉不好看，就可以在上文所提的custom.styl加入：
文件位置：~/blog/themes/next/source/css/_custom/custom.styl
```
// 自定义的侧栏时间样式
#days {
    display: block;
    color: rgb(7, 179, 155);
    font-size: 13px;
    margin-top: 15px;
}
```