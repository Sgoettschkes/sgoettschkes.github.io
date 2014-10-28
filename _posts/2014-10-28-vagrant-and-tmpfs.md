---
layout: post
category: dev
tags: [dev, vagrant, tmpfs, devops]
title: "Vagrant and tmpfs"
author: Sebastian
date: 2014-10-28 15:09:00 UTC
---
When I am talking about Vagrant at usergroups and conferences, one thing I always mention is that shared folders are slow, especially with Virtualbox. While it's true for reading to some extend, the biggest bottleneck I experience is writing to the shared folder. This happens a lot with cache and logs in development mode when you use e.g. symfony2. These folders live inside the project dir and depending on your project structure you might not be able to redirect them to some folder inside the vm.

## Mounting inside share folders

At the vagran workshop for ViennaPHP, somebody mentioned to me the possibility to mount shared folders inside the virtual machine as a tmpfs drive. This surprised me because I was under the impression that you cannot mount folders inside a shared folder. Turns out you can, which opens a lot of possibilities.

One is mounting the cache and log dir as a tmpfs drive, bypassing the shared folder and keeping the cache files and logs in RAM. As writing do disk is slower than using the RAM, this should make things faster. Compared to shared folders, it should be huge improvement.
The disadvantage of this is that all files will be gone after the machine is powered off and that you can't access it easily from your host.

## "Benchmarking"

In order to test this, I created a small python script which creates 10.000 files with one line of text and deletes them afterwards. I let it run with three targets: a folder inside the vm, a synced folder and a tmpfs folder.

To my surprise, it's faster to write to a folder inside a vm then to tmpfs. This might be because of the virtualization of the RAM which adds overhead. But, as I expected it's much faster (about 10 times as fast) to use tmpfs than writing to a shared folder. The exact numbers for me were:

* Normal folder inside the vm: 2.33s
* Shared folder: 38.99s
* tmpfs folder: 4.15s

## Other ways to improve vagrant performance

Of course there are other ways to speed up your vagrant setup. You can try various things:

* Use a different provider: Virtualbox is good and free, but VMWare will give you more speed for sure.
* Use nfs/samba/rsync: You can try using a different way of sharing folders. The build-in shared folders work, but as said are pretty slow. Try nfs or samba on Windows and see if this works out better. Try rsync as well (which is getting better but is not there yet). Maybe some other strategy works as well?
* Look for other resources: Just as this post there are many blog posts out there with tips on making stuff faster.

And then there is docker, which might take away most of the overhead but adds complexity and doesn't really isolate development environments. If I find the time to research a bit more, I'll put a post on docker up as well!
