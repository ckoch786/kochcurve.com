---
layout: page
title: Archive
permalink: /archive/
---
<section class="page-header">
  <h1>Archive</h1>
  <p>All published posts, sorted by newest first.</p>
</section>
<section class="post-list">
  {% for post in site.posts %}
  <article class="post-card">
    <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
    <p class="post-meta">{{ post.date | date: "%B %d, %Y" }}{% if post.author %} • by {{ post.author }}{% endif %}</p>
    <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
    <a class="read-more" href="{{ post.url }}">Read post →</a>
  </article>
  {% endfor %}
</section>