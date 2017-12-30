{% extends '_layout.swig' %}
{% import '_macro/post-collapse.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %} {{ __('title.tag') }}: {{ page.tag }} | {{ config.title }} {% endblock %}

{% block content %}

  <div id="posts" class="posts-collapse">
    <div class="collection-title">
      <h2 >
        {{ page.tag }}
        <small>{{  __('title.tag')  }}</small>
      </h2>
    </div>

    {% for post in page.posts %}
      
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

      {{ post_template.render(post) }}
    {% endfor %}
  </div>

  {% include '_partials/pagination.swig' %}
{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}

{% block script_extra %}
  {% if theme.use_motion %}
    <script type="text/javascript" id="motion.page.archive">
      $('.archive-year').velocity('transition.slideLeftIn');
    </script>
  {% endif %}
{% endblock %}
