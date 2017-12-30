title: hexo next主题添加tag的时间轴
author: Ciwei
tags:
  - hexo
categories:
  - hexo
date: 2017-12-30 21:30:00
---
### 时间轴页面的年份分隔
在 Archives（归档）页面，文章之间有年份分隔，而某一个 category 和 tag 的时间轴页面却没有。怎么办呢？修改两个文件，加代码即可relieved啦
<!--more-->
category（分类）
加到哪？要加两个位置：
文件位置：~/blog/themes/next/layout/category.swig
```
     {% for post in page.posts %}
              位置A
       {{ post_template.render(post) }}
     {% endfor %}
.
.
.（省略好多行）
.
.
位置B（没错最后面）
```

### 位置A添加：
```
      {# Show year #}
      {% set year %}
      {% set post.year = date(post.date, 'YYYY') %}

      {% if post.year !== year %}
        {% set year = post.year %}
        <div class="collection-title">
          <h2 class="archive-year motion-element" id="archive-year-{{ year }}">{{ year }}</h2>
        </div>
      {% endif %}
      {# endshow #}
```

### 位置B添加（最后面添加）：
```
{% block script_extra %}
  {% if theme.use_motion %}
    <script type="text/javascript" id="motion.page.archive">
      $('.archive-year').velocity('transition.slideLeftIn');
    </script>
  {% endif %}
{% endblock %}
```

tag（标签）
文件位置：~/blog/themes/next/layout/tag.swig，其它与的 category 修改完全一样。