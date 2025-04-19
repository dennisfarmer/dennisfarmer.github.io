---
layout: layouts/base.njk
title: Music
---

## My Music Compositions and Arrangements

<div class="card-grid">
{% for piece in collections.music | reverse %}
{% if piece.url != '/music/' %}
<a href="{{ piece.url }}" class="card">
{% if piece.data.image %}
<img src="{{ piece.data.image }}" alt="{{ piece.data.title }}" class="card-image">
{% endif %}
<div class="card-content">

{% if piece.data.tag == 'SLP 2025' %}
<h5 class="card-coming-soon"> SLP 2025: Coming Soon...</h5>
{% endif %}

{% if piece.data.tag == 'SLP 2024' %}
<h5 class="card-snow-day"> SLP 2024: Snow Day!</h5>
{% endif %}

{% if piece.data.tag == 'SLE' %}
<h5 class="card-sle">South Lyon East Front Ensemble</h5>
{% endif %}

<h3 class="card-title">{{ piece.data.title }}</h3>
{% if piece.data.description %}
<p class="card-description">{{ piece.data.description }}</p>
{% endif %}
{% if piece.data.date %}
<p>{{ piece.data.date.toLocaleString('default', {month: 'long'}) }} {{ piece.data.date.getFullYear() }}</p>
{% endif %}
</div>
</a>
{% endif %}
{% endfor %}
</div>
