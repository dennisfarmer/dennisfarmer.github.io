---
layout: layouts/base.njk
title: Projects
---

## Projects

<div class="card-grid">
{% for project in collections.projects %}
{% if project.url != '/projects/' %}
<a href="{{ project.url }}" class="card">
{% if project.data.image %}
<img src="{{ project.data.image }}" alt="{{ project.data.title }}" class="card-image">
{% endif %}
<div class="card-content">
<h3 class="card-title">{{ project.data.title }}</h3>
{% if project.data.description %}
<p class="card-description">{{ project.data.description }}</p>
{% endif %}
</div>
</a>
{% endif %}
{% endfor %}
</div>
