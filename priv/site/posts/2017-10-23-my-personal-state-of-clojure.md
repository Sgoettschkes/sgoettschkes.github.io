---
layout: _post.html.eex
category: dev
tags: [clojure, clojurescript, compojure, reagent, re-frame]
title: "My personal state of Clojure"
author: Sebastian
date: 2017-10-23 10:00:00 UTC
permalink: p/my-personal-state-of-clojure.html
---
Almost a year ago I wrote my last blog post on this blog. It wasn't planned, it just happened. I was busy doing other, unrelated things and while I sometimes had something to say, I never took the time to take it to my blog. As with many things which are not top priority, it got lost along the way.

As a comeback, I figured a personal look into Clojure might be interesting for some. Let's go!

## One year with Clojure

We started using Clojure for a new project (green-field, as some might say) at Blossom. We are building the project alongside running Blossom and other projects, which means progress is naturally slow. We also decided to look into Datomic as well, harming progress even further. But while we removed Datomic from our stack again, we keep Clojure and Clojurescript. Getting used to Clojure and Clojurescript took some times as well but now I feel good about the way I write code and I grew to like it a lot. I still got much to learn, but that's ok as I like learning new things. Beside work, I used Clojure for 3 side projects (a Chatbot, a article-based website and a map-based web app).

## Clojure as a language

I have worked with many languages over the years. Clojure feels more mature than many other "small" languages, both the language itself as well as the ecosystem. Leiningen is a great tool for managing dependencies and to buid your project. Built on top of the JVM means that running the application in production is possible everywhere where you'd be able to run Java applications.

After some time to get used to the Clojure way, I am very fast implementing features in Clojure. Having the codebase split up into many small functions which are pure in most cases makes it easy to plug them together in new ways, remove a certain step or add another one. Testing is easy as well, given that Clojure works with data most of the time.

And, before the argument comes up: Sure, just having (pure) functions doesn't protect you from a messy code base. You can have unreadable, untraceable code in almost any language. But my personal feeling is that by sticking to small functions and trying to keep them pure goes a long way towards good software.

The Clojars repository contains many packages and I haven't had any problems finding the libraries I needed throughout the year. Having the possibility to add Maven dependencies or Jar files if no Clojure library is available adds to the ecosystem as well. Using Java libraries isn't as smooth as the ones written in Clojure, but that's mostly due to the underlying differences in thinking than a shortcoming of Clojure. And even though it sometimes feels weird, it works quiet well.

## The community

Clojure has a small, nice community. You can feel the excitment about the language at our local Usergroup as well as when talking about Clojure at conferences and with fellow developers. Many times I had people jumping in to help me with my problems and being nice. I also don't feel like I am looked down on or anything if I don't understand a certain concept. In languages like Haskell I always felt a little stupid for not knowing how to solve a certain problem "the functional way". I didn't have this feeling in Clojure.

As with any other small language, having a small community has drawbacks. Sometimes, you come across a problem nobody ever had. This is rare in the big languages as almost everything has been done. Sometimes, you are looking around and while it seems others have solved the problem, they didn't openly discuss it. Again, it happens because of the smaller amount of people around.

Additionally, the opinion of a few does make a lot more noise in a small community. It did show recently as a negative blog post hit Hackernews and reddit and the community started discussing. I don't think a post like this would hit the Javascript or Python community as hard. With this in mind, it becomes even more crucial to try to discuss in a civil manner than to attack. People are spending their free time so we all can benefit. Even if you don't like or don't agree, showing some decency and respect for the work goes a long way.

## Getting payed

Beside Blossom, I do some freelancing and while I'd love to use Clojure there as well, I wasn't able to find any opportunities yet. The market for Clojure developers seems small. I was surprised to see some Clojure job posts on Upwork and have applied there, without much success yet.

In Vienna, there are some companies using Clojure for their products. I am excited for their success stories and the inspiration for other companies to make the bold move and invest in a rather small language. I feel that with the Java interoperability the risks of such a move are minimized.

Should you drop everything else and learn Clojure? I don't think so. Make sure to experiment with Clojure. If you like it and if you feel you could be more productive, try to incorporate it into existing projects or new ones. But don't just try Clojure. See if Erlang/Elixir is for you, if you can get more done with another "big" language or if you are still happy with your language of choice.

I don't see Clojure as a game changer, just as a nicer, cleaner way to express intend. But that's a lot of what a language should foster, right?
