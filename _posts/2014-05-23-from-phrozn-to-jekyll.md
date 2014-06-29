---
layout: post
category: blogging
tags: [blogging, static site generators, jekyll, phrozn]
title: "From Phrozn to Jekyll"
author: Sebastian
date: 2014-05-23 20:22:00 UTC
---
As you might know by now, I like static side generators. They combine the flexibility of a templating system with the easy deployment of static pages. Creating pages feels like working in a programming language and deploying the page in the end is as easy as putting some html files on an ftp (which you shouldn't do, of course). There is no need for a complicated setup or deployment process because it's just some HTML served from nginx (or any other webserver). You can put the files on Amazon S3, your own host or github pages. And as it's only static files being served, performance is as good as it gets.

## Jekyll and Hyde

I discovered [Jekyll](http://jekyllrb.com/) a while ago and gave it a test run. It worked very good and I was impressed. As I said, I really liked the HTML output which can be put almost everywhere. There was one major problem for me at least: Deploying to github pages was a pain if you wanted to use plugins, because github runs Jekyll with the `safe` option, which means that no local plugins are used. This is understandable because plugins would make it possible to run any kind of ruby code on the github servers.

To make it work, the "default" solution back then was to put the Jekyll source files into a branch like `source`. There you would generate the HTML into the `_site` directory and have a post-commit hook, which took the changeset of each commit, extract the objects which changed in the `_site` directory and create a new commit in the `master` branch with these. It was a little hacky, but it worked most of the time.

I felt, however, that this was a bit complicated and made collaboration harder than needed. First of all, the `source` branch had both the Jekyll source files as well as the generated HTML in source control. I'm not a huge fan of this because it means you can get in pretty weird situations where you change a source file but not run Jekyll, meaning the HTML stays the same. It also makes it easy for collaborators to change the HTML directly, commit it and have it overwritten the next time somebody else uses Jekyll to generate the HTML.

The hack itself felt wrong as well. First and foremost, not having the post commit hook in place messes everything up. Pull requests are impossible to manage. A change in the `source` branch which doesn't change the output (settings or changes in a draft/unpublished page) creates an empty commit in the `master` branch. All this can be managed somehow, but it seems like to much hassle.

## Enter Phrozn

Looking for a static site generator for [ViennaPHP](http://www.viennaphp.org), it made sense to look in the PHP world, It's a PHP Usergroup after all, so using something from the PHP ecosystem looked like the right choice. I found Phrozn and started to use it soon after.

The one thing I loved immediatly was that Phrozn stores the source files in a `.phrozn` directory and puts the generated HTML in the root directoy, which means you don't need any workarounds for github pages. Just commit, push to the github repo and you're done. Awesome!

The most basics tasks worked well with Phrozn. Make a layout, make a static page, add some CSS with Sass and some javascript. Very cool! Problems started when I tried realizing this blog. The documentation is mostly non-existing or outdated. Generating a index page with the last posts, which is easy in Jekyll, seemed undoable.

Looking for solutions I discovered that the last commit to the Phrozn github repository is 8 month old and there are issues unsolved for a year and more. The documentation on plugins is outdated for over 2 years as far as I understand.

Don't get me wrong: This is open source and I am not complaining that somebody decided to use his spare time on something else than the project I need right now. I fully understand that. But I won't use my time to learn a tool which is not activly developer anymore. I also don't have time to develop it myself. And that's why I decided to abandon Phrozn and migrate to something else.

## Back to square one

I looked around once more and stumbled upon [StaticGen](http://www.staticgen.com/), a page listing many static site generators. Jekyll is leading the list in any way possible. It is the most popular one, has a great documentation and many supporters. There is a good plugin system and it just works.

Everything I liked about Jekyll the first time came back when I took it for a test drive to see what changed. The only thing bugging me back then was the deployment to github pages, so I tried to find a solution that does not suck as much. I found a [blog post](http://ixti.net/software/2013/01/28/using-jekyll-plugins-on-github-pages.html) by [@zapparov](https://twitter.com/zapparov) showing a Rakefile which publishes a Jekyll page to github. 

The idea is to make a temporary directory, copy the `_site` dir there, initialize a git repository, commit and then do a `git push --force` to the `master` or `gh-pages` branch. At first, that seemed strange. But the more I think about it, the more I like it. Ignoring the `_site` directory with git means the `source` branch only contains the Jekyll source files. The `master` branch has no history and only a generic commit message, but then again ot is only there for github pages. The history can be seen in the `source` branch. Contributers can do a pull request against this branch. It can be merged locally and is put into production by executing the rake task. It's also pretty clear that in order to change the page, you need to modify the Jekyll source.

The idea to use a Rakefile has some additional benefits. It got me thinking what else I can automate. I got an idea to send an update.xml to Google everytime something on the page changes using a Rakefile. Maybe there is a plugin - If not, I might write one.

## Lessons learned

The most troubling thing for me was to discover that Phrozn isn't developed anymore. I'll make sure to check the state of development and if there is a community behind the project if it looks like becoming a big part of my setup. It also showed me once more that no software does 100% what you need. There is (almost) always a trade-off - Choose wisely.
