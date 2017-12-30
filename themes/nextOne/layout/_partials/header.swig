<div class="site-meta {% if theme.custom_logo.enabled %}custom-logo{% endif %}">
  {% if theme.custom_logo.image and theme.scheme === 'Muse' %}
    <div class="site-meta-headline">
      <a>
        <img class="custom-logo-image" src="{{ theme.custom_logo.image }}"
             alt="{{ config.title }}"/>
      </a>
    </div>
  {% endif %}

  <div class="custom-logo-site-title">
    <a href="{{ config.root }}"  class="brand" rel="start">
      <span class="logo-line-before"><i></i></span>
      <span class="site-title">{{ config.title }}</span>
      <span class="logo-line-after"><i></i></span>
    </a>
  </div>
    {% if theme.seo %}
      <h1 class="site-subtitle" itemprop="description">{{ config.subtitle }}</h1>
    {% else %}
      <p class="site-subtitle">{{ config.subtitle }}</p>
    {% endif %}
</div>

<div class="site-nav-toggle">
  <button>
    <span class="btn-bar"></span>
    <span class="btn-bar"></span>
    <span class="btn-bar"></span>
  </button>
</div>

<nav class="site-nav">
  {% set hasSearch = theme.swiftype_key || theme.algolia_search.enable || theme.tinysou_Key || config.search %}

  {% if theme.menu %}
    <ul id="menu" class="menu">
      {% for name, path in theme.menu %}
        {% set itemName = name.toLowerCase() %}
        <li class="menu-item menu-item-{{ itemName }}">
          <a href="{{ url_for(path) }}" rel="section">
            {% if theme.menu_icons.enable %}
              <i class="menu-item-icon fa fa-fw fa-{{theme.menu_icons[itemName] | default('question-circle') | lower }}"></i> <br />
            {% endif %}
            {{ __('menu.' + itemName) }}
          </a>
        </li>
      {% endfor %}

      {% if hasSearch %}
        <li class="menu-item menu-item-search">
          {% if theme.swiftype_key %}
            <a href="javascript:;" class="st-search-show-outputs">
          {% elseif config.search || theme.algolia_search.enable %}
            <a href="javascript:;" class="popup-trigger">
          {% endif %}
            {% if theme.menu_icons.enable %}
              <i class="menu-item-icon fa fa-search fa-fw"></i> <br />
            {% endif %}
            {{ __('menu.search') }}
          </a>
        </li>
      {% endif %}
    
<!-- 参考Never_yu的High一下功能 
     网站位置：https://neveryu.github.io/2016/09/30/hexo-next-two,
               https://neveryu.github.io/2016/11/11/hexo-next-three/-->
    <li class="menu-item"> <a href='javascript:(
    function go() {
      var songs = [
          "http://music.163.com/song/media/outer/url?id=479422062.mp3",
          "http://music.163.com/song/media/outer/url?id=481859184.mp3",
	  "http://music.163.com/song/media/outer/url?id=490595323.mp3"
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

</ul>
  {% endif %}

  {% if hasSearch %}
    <div class="site-search">
      {% include 'search.swig' %}
    </div>
  {% endif %}
</nav>

{% include '../_custom/header.swig' %}
