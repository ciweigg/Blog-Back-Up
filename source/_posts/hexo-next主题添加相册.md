title: hexo next主题添加相册
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2018-01-01 15:49:00
---
我研究了好几天才做完这个东西的，哎还去了解了JS，对我这个后台来说前台真是好难呀
转载请注明出处
![paste image](http://oisa91ton.bkt.clouddn.com/1514793010805lknaui0q.png?imageslim)
<!--more-->
言归正传：
### 1.hexo创建一个photo的page
```
hexo new page photo
```
### 2.需要一个生成json的脚本：
photo-tool.js
./photos/ 是当前目录下的文件夹，里面存放照片的哦（照片格式2018-01-01_照片.jpg）
../source/photo/data.json 是生成的json文件存放位置
photo-tool.js脚本和photos文件夹放在一起就行了 可以放在hexo根目录
src替换成自己存放照片的github路径
```

"use strict";
var fs = require("fs");
var path = "./photos/";
fs.readdir(path, function (err, files) {
    if (err) {
        return;
    }
    var arr = [];
    var arrs =[];
  var a = {
    'info' : []
  };
    var date = new Date();
    (function iterator(index) {
        if (index == files.length) {
            fs.writeFile("../source/photo/data.json", JSON.stringify(a, null, "\t"));
            console.log('get img success!');
            return;
        }

        fs.stat(path + files[index], function (err, stats) {
            if (err) {
                return;
            }
            if (stats.isFile()) {
                arrs=files[index].split("_");
                var ym =[];
                ym = arrs[0].split("-");
                var y = ym[0];
                var m = ym[1];
                var texts =[];
                texts = arrs[1].split(".");
                var text = texts[0];
                a.info.push({"src":"https://raw.githubusercontent.com/ciweigg/blog-back-up/master/shell/photos/"+files[index] ,"y":y ,"m":m ,"text":text});
            }
            iterator(index + 1);
        })
    }(0));
});
```
>执行脚本node photo-tool.js

### 3.在github需要创建一个照片备份的仓库
当然不一定要放在github，七牛云啊什么的都可以的
照片使用hexo b 上传，或者直接手动上传github仓库就行
### 4.创建个获取相册的album.js
我使用的是next主题，所有js都放在这个目录下面：
cat themes/nextOne/source/js/src/album.js 
编辑album.js
只需要修改此处就行了：url:'/photo/data.json'
/photo/data.json 相对路径=hexo根目录source下面的，就是上面所生成的page目录下面
```
function getList(){
           var imgData=getImgData();
                ctrler(imgData);
};


function changeSize(){
   if($(document).width() <= 600){
                $(".img-box").css({"width":"auto", "height":"auto"});
        }else{
                //根据设配宽度处理图片显示尺寸
                var width = $(".img-box-ul").width();
                var size = Math.max(width*0.28, 155);   
                $(".img-box").width(size).height(size);
        }
        $('.instagram img').each(function() {
                $(this).css("height", size);
                $(this).css("width", size);
        })
};


function bind(){
        $(window).resize(function(){
                changeSize();
        });
};


function ctrler(data){
   var imgObj = {};
        for(var i=0,len=data.length;i<len;i++){
                var y = data[i].y;
                var m = data[i].m;
                var src = data[i].src;
                var text = data[i].text;
                var key = y+""+((m+"").length == 1?"0"+m : m);
                if(imgObj[key]){
                        imgObj[key].srclist.push(src);
                        imgObj[key].text.push(text);
                }else{
                        imgObj[key] = {
                                year:y,
                                month:m,
                                srclist:[src],
                                text:[text]
                        }
                }
        }
        render(imgObj);
};


function getImgData(){
   var content;
        $.ajax({  
        url:'/photo/data.json',  
        async:false,
        success:function(data){
                content=data;
        }  
    }); 
    content=eval(content)
    content=content.info
        return content;
};


function render(data){
   var ulTmpl = "";

        for(var em in data){
                var liTmpl = "";
                for(var i=0,len=data[em].srclist.length;i<len;i++){
                        liTmpl += '<li>\
                                                        <div class="img-box">\
                                                                <a class="img-bg" rel="example_group" href="'+data[em].srclist[i]+'" title="'+data[em].text[i]+'"></a>\
                                                                <img  class="lazy"  src="'+data[em].srclist[i]+'" data-original="'+data[em].srclist[i]+'">\
                                                        </div>\
                                                </li>';
                }


                ulTmpl ='<section class="archives album"><h1 class="year">'+data[em].year+' ^<em>'+data[em].month+'月</em></h1>\
                        <ul class="img-box-ul">'+liTmpl+'</ul>\
                        </section>'+ ulTmpl;
        }
        ulTmpl='<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=520 height=86 src="//music.163.com/outchain/player?type=2&id=300066&auto=1&height=66"></iframe>'+ulTmpl;
        $(ulTmpl).appendTo($(".instagram"));
        changeSize();

        $("img.lazt").lazyload();  

        $("a[rel=example_group]").fancybox({
        'width' : 450,
        'height' : 450,
        });

};


$(document).ready(function(){
        getList();
        bind();

});
$(document).bind("contextmenu",function(e){   
          return false;   
});
```

### 5.修改样式
next主题目录（其他主题只要找到存放css的地方就行）：
vi themes/nextOne/source/css/_custom/custom.styl 
最后添加（当然了自己可以随意更改）：
```
.instagram {
  position: relative;
  min-height: 500px;
}
.instagram .open-ins {
  display: block;
  padding: 10px 0;
  position: absolute;
  right: 28px;
  top: -75px;
  color: #333;
}
.instagram .open-ins:hover {
  color: #657b83;
}
.instagram .year {
  display: inline;
}
.instagram .album h1 em {
  font-style: normal;
  font-size: 14px;
  margin-left: 10px;
}
.instagram .album ul {
  min-height: 250px;
  padding-top: 13px;
  border-bottom: 1px solid #ddd;
  list-style: none;
}
.instagram .album li {
  position: relative;
  display: inline-block;
  min-width: 250px;
  margin: 0;
}
.instagram .album li:before {
  display: none;
}
.instagram .album div.img-box {
  position: relative;
  margin: 0 15px 8px;
  -webkit-box-shadow: 0 1px 0 rgba(255,255,255,0.4), 0 1px 0 1px rgba(255,255,255,0.1);
  -moz-box-shadow: 0 1px 0 rgba(255,255,255,0.4), 0 1px 0 1px rgba(255,255,255,0.1);
  box-shadow: 0 1px 0 rgba(255,255,255,0.4), 0 1px 0 1px rgba(255,255,255,0.1);
}
.instagram .album div.img-box .img-bg {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0px;
  width: 100%;
  margin: -5px;
  padding: 5px;
  background: rgba(204,204,204,0.8);
  -webkit-box-shadow: 0 0 0 1px rgba(0,0,0,0.04), 0 1px 5px rgba(0,0,0,0.1);
  -moz-box-shadow: 0 0 0 1px rgba(0,0,0,0.04), 0 1px 5px rgba(0,0,0,0.1);
  box-shadow: 0 0 0 1px rgba(0,0,0,0.04), 0 1px 5px rgba(0,0,0,0.1);
  -webkit-transition: all 0.15s ease-out 0.1s;
  -moz-transition: all 0.15s ease-out 0.1s;
  -o-transition: all 0.15s ease-out 0.1s;
  transition: all 0.15s ease-out 0.1s;
  opacity: 0.2;
  cursor: pointer;
  display: block;
}
.instagram .album div.img-box .img-bg:hover {
  opacity: 0;
}
.instagram .album div.img-box img {
  width: 100%;
  height: auto;
  display: block;
}
@media screen and (max-width: 600px) {
  .instagram .album ul {
    margin-left: 0;
    padding: 0;
    text-align: center;
  }
  .instagram .album li {
    max-width: 400px;
  }
  .instagram .album div.img-box {
    margin: 0;
  }
}
```
### 6.最后修改刚才创建的photo page
 vi source/photo/index.md
 添加：
 jquery.min.js自己百度去下载
 此处的相对路径对应主题的source
 ```
<link type="text/css" href="/lib/fancybox/source/jquery.fancybox.css" rel="stylesheet">
<div class="instagram">
    <!-- <<section class="archives album">
        <ul class="img-box-ul"></ul>
    </section> -->
</div>
<script type="text/javascript" src="/js/src/jquery.min.js"></script>
<script type="text/javascript" src="/js/src/album.js"></script>
```

别忘了在主题的_config.yml中添加相册菜单呀

最后发布
hexo g
hexo s
就能看到相册啦