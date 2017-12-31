title: hexo 添加追剧功能
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-31 21:05:00
---
### 安装
Hexo 的脚本插件是 Hexo 插件的一种特殊形式，仅当插件简单到不需要依赖 Hexo 之外的其他模块时使用。
![paste image](http://oisa91ton.bkt.clouddn.com/1514725931093d9xhh8v0.png?imageslim)
<!--more-->
```
cd myblog
mkdir -p scripts && cd scripts
vi image-stream.js
添加如下内容：
'use strict';

var config = {
  'jquery': '//cdn.bootcss.com/jquery/2.1.0/jquery.min.js',
  'jquery_lazyload': '//cdn.bootcss.com/jquery.lazyload/1.9.1/jquery.lazyload.min.js',
  'img_placeholder': 'https://ws4.sinaimg.cn/large/e724cbefgw1etyppy7bgwg2001001017.gif'
}

if (hexo.config.image_stream) {
  for (var key in config) {
    if (hexo.config.image_stream[key] != null) {
      config[key] = hexo.config.image_stream[key];
    }
  }
}

hexo.extend.tag.register('stream', function(args, content){
  var result = '';
  if (config['jquery']) {
    result += '<script src="' + config['jquery'] + '"></script>';
  }
  if (config['jquery_lazyload']) {
    result += '<script src="' + config['jquery_lazyload'] + '"></script>';
  }
  result += '<div class="hexo-img-stream">';
  result += '<style type="text/css">';
  result += '.hexo-image-steam-lazy {display:block;}.hexo-img-stream{width:90%;max-width:1100px;margin:3% auto}div.hexo-img-stream figure{background:#fefefe;box-shadow:0 1px 2px rgba(34,25,25,0.4);margin:0 0.05% 3%;padding:3%;padding-bottom:10px;display:inline-block;max-width:25%}div.hexo-img-stream figure img{border-bottom:1px solid #ccc;padding-bottom:15px;margin-bottom:5px}div.hexo-img-stream figure figcaption{font-size:.9rem;color:#444;line-height:1.5;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}div.hexo-img-stream small{font-size:1rem;float:right;text-transform:uppercase;color:#aaa}div.hexo-img-stream small a{color:#666;text-decoration:none;transition:.4s color}@media screen and (max-width:750px){.hexo-img-stream{column-gap:0}}';
  result += '</style>';
  result += content;
  result += '</div>';
  result += '<script type="text/javascript">$(\'img.hexo-image-steam-lazy\').lazyload({ effect:\'fadeIn\' });</script>';
  return result;
}, {ends: true});

hexo.extend.tag.register('figure', function(args){
  var imgUrl = args.shift();
  var title = args.join(' ');
  var placeholder = config['img_placeholder'];

  var result = '<figure>';
  result += '<img class="hexo-image-steam-lazy nofancy" src="' + imgUrl + '" data-original="' + imgUrl + '"/>';
  result += '<noscript><img src="' + imgUrl + '"/></noscript>';
  result += '<figcaption>' + hexo.render.renderSync({text: title, engine: 'markdown'}).replace(/<p>/, '').replace(/<.p>/, '') + '</figcaption>';
  result += '</figure>';
  return result;
});
```
### 配置
为了实现开箱即用，插件自带了默认配置，不做额外配置，和在站点的 _config.yml 中使用如下配置等价：
```
image_stream:
  jquery: false
  jquery_lazyload: //cdn.bootcss.com/jquery.lazyload/1.9.1/jquery.lazyload.min.js
```
在博客根目录：
hexo new page favorite
编辑生成的页面：
```
{% stream %}

{% 封面地址 [电视剧名称](电影地址) %}

{% figure https://img3.doubanio.com/view/photo/l/public/p2505089860.webp [可惜不是你](https://movie.douban.com/subject/27026077/) %}

{% endstream  %}
```

电影推荐在豆瓣找哦 ^ ^ happy new year
  