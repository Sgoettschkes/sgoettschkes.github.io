---
layout: post
category: dev
tags: []
title: "Dart and Vagrant"
author: Sebastian
date: 2015-11-18 14:00:00
---
Using Vagrant to provide a reproducible development environment is second nature to me. All projects I work on have a `Vagrantfile` and it usually works great.

## Packages and your IDE

One of the biggest problems when running your code inside a virtual machine is the IDE, at least for me. The code lives on my host machine and is synced into the vm, so I use an editor or IDE on my host. I might not have the needed dependencies on my host machine, so the IDE struggles to provide code completion.

PyCharm (and many other JetBrains IDEs) has the ability to use a remote interpreter for Python. Pointing it to the Vagrant machine, PyCharm won't use the installed interpreter and packages installed locally but will ssh into the virtual machine and get the interpreter as well as all libraries installed through pip from there. This works rather well, so even though I don't have flask installed on my host, I have code completion for the flask API and PyCharm tells me if I am missing an argument. If I use Python 3 for my project and it's installed in the vm, I don't need it on my host at all (In fact, I don't need any Python installed, which is nice if you happen to run Windows).

## Dart and the packages symlinks

The dart plugin for the JetBrains IDEs does not have such a feature. It relies on the dart SDK installed somewhere on your host. I wouldn't mind installing Dart, but there are some problems:

* Different projects might use different versions of the dart SDK. Keeping different versions of the SDK somewhere is tedious.
* pub, the dart package manager, downloads packages to `~/.pub-cache`. All dependencies need to be downloaded twice to be available inside the vm (to execute the code) and on the host (so the IDE can access it). You could also sync your local `pub-cache` folder into the vm to get around this issue.
* pub creates symlinks in your project to reference packages. In your project root, it creates a `packages` folder which contains symlinks to each package. The paths are absolute, so each time you run it inside the vm, it breaks the lookup on the host and vice verse.

I didn't find a solution to my first problem, but could solve the other two!

## .packages to the rescue

As far as the `.pub-cache` folder is concerned, there is a third solution: pub looks up the `PUB_CACHE` environment variable and if it contains a valid path, it puts the dependencies there. This way, you can store all your dependencies in your project root in a `.pub-cache` (or whatever you wanna call it) folder. It's synced to your host automatically, so no need to install the same libraries twice.

The symlinks are a bigger problem, but if you are using dart 1.12 or higher, there is a way around. By using `--no-package-symlinks` as an argument to `pub get` ( or `pub upgrade`), no symlinks are created. Instead, a single `.packages` file is used to store all links for the packages needed. Sadly, this links are again absolute. But with a little bit of dart magic (ok, regex magic), you can change those to be relative and work both on the vm and the host.

If you are using dart before 1.12, you can of course try to rewrite the symlinks which might work as well!

## The rough edges

Because the `PUB_CACHE` environment variable need to be set correctly, I only run `pub get` and `pub upgrade` inside the vm where my provisioning takes care of putting everything in place. On my host, the `PUB_CACHE` might point to a different project, messing everything up.

One also needs to remember to run `pub get` with the correct argument and running the script to replace the links to be relative. If you are using some task runner (like grinder), this is no issue as you have your task and it takes care of doing all the steps needed.

## The state of dart

While this was intended as a practical post about dart in the vm and IDEs, there is an underlying question: Why is it so complicated? Turns out that package management is complicated nonetheless and every package manager I encountered has some problems. NPM downloads every dependency n times, once for each library that depends on it. There is no sharing going on, even if two libraries depend on the exact same version.

pip and gem install packages globally and rely on external solutions (or workarounds) to install dependencies locally for every project. composer installs everything locally but only once, making it the best package manager I worked with in the past. If you work on a lot of projects and all depend on the same set of libraries, there is a certain overhead in downloading those libraries for each project.

pub seems to take into account all those problems: it installs each version needed of each library globally (if you don't mess with the `PUB_CACHE`), which means you can have different projects use different versions of the same library OR use the same library without storing it twice. Of course, within one project you can only use one version of each library, so "dependency hell" is still possible.

## The perfect solution

The best solution would of course be if the dart plugin could use a remote SDK. I doubt this will come anytime soon (I didn't see anybody ranting about it anyway). Having a working solution in place makes working on dart projects which run inside a Vagrant vm much nicer. You should try it!