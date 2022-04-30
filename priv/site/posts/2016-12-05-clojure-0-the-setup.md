---
layout: _post.html.eex
category: dev
tags: [clojure, leiningen, vagrant, adventofcode]
title: "(clojure 0) The setup"
author: Sebastian
date: 2016-12-05 13:00:00 UTC
permalink: p/clojure-0-the-setup.html
---
In the last week I started playing with [Clojure](https://clojure.org/). The reason for this are some upcoming projects with the blossom Team. The stack will most likely be Clojure in the backend and [ClojureScript](https://clojurescript.org/) in the frontend. So I better up my game. I started with the [Advent of Code](http://adventofcode.com/) to have some real world exposure and not just write complicated "Hello, World" code. I'm planning on writing a series of blog posts, documenting my journey.

## Vagrant

People who know me knew this was coming. I start every project in a clean vm managed by [Vagrant](https://www.vagrantup.com/) to not clutter my laptop, remove stuff without a trace and not get caught in some weird dependency hell. I also got a vagrant setup for learning new stuff which is usually my go-to project when working on things like "Advent of Code".

So the first step for me was to add Clojure to the tech stack inside the Vagrant machine. To be honest, I expected some problems. There usually are. The only real easy setup I ever had was Dart, wehre downloading the zip and extracting it is all you really need. With clojure, it was almost as easy. Make sure Java is installed, download the leiningen script, make sure it's executable and in the path, done.

## Clojure and Leiningen

[Leiningen](http://leiningen.org/) to me feels like a package manager on steriods and I love it. Using Leiningen to install Clojure is pure joy because it does it automatically. No need to figure anything out on your own. And it just works. I never installed something explicitly. If I add a dependency to my `project.clj` and run or test the project, Leiningen discovers the change and installs it automatically. I'm still amazed by how easy it feels to work with Leiningen.

Leiningen also creates a new project scaffolding if you need it. Perfect for newcomers who have no idea how a project setup in Clojure looks like `lein new PROJECTNAME` and lein got you covered. You can use Leiningen to run the project, test it and build it as needed.

# Tests included

The new project also includes an incomplete test, urging you to fix it. This is great because it makes sure there is a working test setup included in the scaffolding make it easier to get started with tests. Nobody can be forced to write tests, but the easier it is to get started the more likely developers are to pick it up. And it's more fun as well!

In the next part I'll talk about the first Advent of Code solutions as well as my feeling about Clojure after working with it a bit. Stay tuned ;)
