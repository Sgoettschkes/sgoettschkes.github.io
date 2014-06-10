---
layout: post
category: dev
tags: [dev, development, jekyll, rake, ruby]
title: Jekyll: Update your sitemap automatically with rake
author: Sebastian
date: 2014-05-31 18:48:00 UTC
---
If you write your blog to also be found through Google, you may have a sitemap which makes it easy for Google and Bing to crawl your page. It might be good idea to inform both if this sitemap changes so they can send their crawlers your way and update their index with the great stuff you just put on their. This can be done by doing a `GET` request and passing the url to your sitemap as a parameter. Easy as pie, right?

## But my page is static

If you are running a wordpress blog or some other dynamic blogging engine, there is a chance that sending this request is either build in or available as a plugin. If not, you can always develop the parts yourself. But what if you are using Jekyll or another static blogging engine which doesn't execute any code on the server.
