---
layout: layouts/base.njk
title: Posts
---

## Posts

<div class="card-grid">
{% for post in collections.posts | reverse %}
{% if post.url != '/posts/' %}
<a href="{{ post.url }}" class="card">
{% if post.data.image %}
<img src="{{ post.data.image }}" alt="{{ post.data.title }}" class="card-image">
{% endif %}
<div class="card-content">
<h3 class="card-title">{{ post.data.title }}</h3>
{% if post.data.description %}
<p class="card-description">{{ post.data.description }}</p>
{% endif %}
</div>
</a>
{% endif %}
{% endfor %}
</div>
