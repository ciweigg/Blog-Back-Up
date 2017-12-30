title: hexo next主题添加音乐
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-30 21:03:00
---
隐藏的音乐播放器
在之前主题的时候就添加过一次背景音乐，不过效果不是很好。两个缺点：首先因为是直接调用的网易云音乐的外链播放器，不能够隐藏，和整体的风格不是很搭；其次是在手机端上的浏览器时需要点击触发，效果不是很好。
<!--more-->
### 修改：
文件位置：\themes\next\layout\ _partials\header.swig
代码插入位置： 在 ul 标签之间加入以下代码：
如果你的主题不是左右的话 是左右格式的话 去掉末尾的<br>

```
<!-- 参考Never_yu的High一下功能 
     网站位置：https://neveryu.github.io/2016/09/30/hexo-next-two,
               https://neveryu.github.io/2016/11/11/hexo-next-three/-->
    <li class="menu-item"> <a href='javascript:(
    function go() {
      var songs = [
          "http://m2.music.126.net/O8RMqPVgtz5Qp_i1PBeBaQ==/5969248627774562.mp3",
          "http://m2.music.126.net/3HglVSQUxqesNvCL2WKBUg==/1244647162662086.mp3"
      ];
 
      function S() {
          var e = document.getElementById("audio_element_id");
          if(e != null){
              var index = parseInt(e.getAttribute("curSongIndex"));
              if(index > songs.length - 2) {
                  index = 0;
              } else {
                  index++;
              }
              e.setAttribute("curSongIndex", index);
          }
          e.src = i;
          e.play()
      }
      function initAudioEle() {
          var e = document.getElementById("audio_element_id");
          if(e === null){
            e = document.createElement("audio");
            e.setAttribute("curSongIndex", 0);
            e.id = "audio_element_id";
            e.loop = false;
            e.bgcolor = 0;
            e.innerHTML = " <p>If you are reading this, it is because your browser does not support the audio element. We recommend that you get a new browser.</p> <p>";
            document.body.appendChild(e);
            e.addEventListener("ended", function() {
              go();
            }, true);
          }        
      }
    
      initAudioEle();
      var curSongIndex = parseInt(document.getElementById("audio_element_id").getAttribute("curSongIndex"));
      var i = songs[curSongIndex];
      S();
    })()'>
    <i class="menu-item-icon fa fa-music fa-fw"></i><br>楽</a> </li>
<!-- end High一下 -->
```

### 查找歌曲：
想添加别的音乐的话，需要直接在代码中修改 var songs = [ ] 的网址。
需要注意的是网址需要的音乐是直链外链，我用的网易云音乐

链接模板：
http://music.163.com/song/media/outer/url?id=.mp3
id在网易云中查找：
打开歌曲地址栏就有id了：

![paste image](http://oisa91ton.bkt.clouddn.com/1514639262431lh9188u2.png?imageslim)

### 例子：
这样就行啦：http://music.163.com/song/media/outer/url?id=490595323.mp3

参考链接：http://wellliu.com/2016/11/22/Blog%E6%B7%BB%E5%8A%A0%E6%A5%BD%E5%8A%9F%E8%83%BD/
