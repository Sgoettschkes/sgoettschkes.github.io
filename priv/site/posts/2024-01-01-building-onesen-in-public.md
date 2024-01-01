---
layout: _post.html.eex
category: dev
tags: [elixir, phoenix, javascript, onesen, buildinpublic]
title: "Building OneSen in public"
author: Sebastian
date: 2023-01-01 16:45:00 UTC
permalink: p/building-onesen-in-public.html
---

![A unique visual representation of the 'OneSen' note-taking app](/img/2024-01-01-building-onesen-in-public.png "A unique visual representation of the 'OneSen' note-taking app")

It's been a while since I posted on my blog. Almost two years, to be precise. I was focusing my energy on other parts of my life, and, to be honest, I never got back into publishing regular blog posts after falling off the wagon in 2017. But now I am back, and I intend to publish more often.

## Building OneSen

Last week, I started a new side project. It's called OneSen, and currently, it's a text field you can use to store your daily notes. In the future, I envision it to be a note-taking app focusing on daily notes (much like micro-blogging) and simplicity. I also have ideas to add the capabilities of LLMs to enrich the experience and get insights into your notes.
The alpha version, without a design, text, or explanations, can be found at [https://onesen.app](https://onesen.app). But it works 😉

## Build in public

My current plan is to build this app in public. I like the idea of (radical) transparency, which is present when being open about everything happening. I like to teach others what works for me and what doesn't. I like to inspire others to build something on their own, make their work more public, or share more. We can all benefit from the experiences others have already had.

## The idea

To be transparent, I have to give credit where credit is due. The idea for OneSen came from Dainius, who mentioned that he'd like a straightforward interface to take notes and have them stored daily, much like a physical notebook with its pages dedicated to a specific date.

I let the idea sit, and because I thought about it more over time, I decided to act on it. I kept the notebook analogy since the concept closely relates to physical notebooks. Currently, each notebook contains pages, one page for each day. A user can only change the current day, and the system saves changes automatically when the text changes. It's as easy as possible. Go to your notebook, write something, and leave.

## The MVP

My current plan for the MVP is to add a design, make it possible to view past dates and rename notebooks. Those changes should be enough to make it usable and see if people want something like this. 

## The long term vision

OneSen could go in many directions. One idea I had was the "One second a day" video app for writing. Write something daily and combine it per week, month, or year.

Another idea was to add LLM capabilities, analyze notes, and gather insights using AI. This feature could be interesting for people writing morning pages or journals.

I am also thinking about encrypting notes on the client, adding security that almost no other note-taking app has. The drawback would be that working with notes would need to happen on the client since even searching would not be possible with encrypted notes.
