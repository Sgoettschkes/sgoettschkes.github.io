---
layout: post
category: dev
tags: [dev, vagrant, base boxes, debian, chef, ansible]
title: "Vagrant base boxes"
author: Sebastian
date: 2015-01-27 22:05:00 UTC
---
If you are using vagrant on a daily basis, you might already be using something else than the base box suggested by vagrant (which would be the `hashicorp/precise32` or `hashicorp/precise64`). If you are thinking about creating your own base boxes or are interested in the topic, read on. If you have no idea what I am talking about, the vagrant documentation can tell you more about [Boxes](https://docs.vagrantup.com/v2/boxes.html).

I got to the point where I wanted to use Debian instead of Ubuntu and, looking through Vagrant Cloud (now [Atlas](https://atlas.hashicorp.com)) no box did really appeal to me. So I decided to build my own base box on top of the [chef/debian-7.4](https://atlas.hashicorp.com/chef/boxes/debian-7.4). I am using vagrant to build this base box, meaning I have a `Vagrantfile` which imports the chef base box, then some shell provisioning to install the absolut minimum I need for every box (packages like `vim` for example).

This is pretty handy: If chef updates their base box I can update my base box just by destroying it, building it new, packaging it and uploading it to Atlas. If I decide to add some new software, the same workflow applies. Provision it again, package it, upload it.

It also means I don't have to work with [packer](https://www.packer.io/intro), which seems like an amazing tool but is just not what I want to spend my time on right now.

## Evolution of a base box

I started my base box pretty simple with one Vagrantfile and some shell provisioners inside. Afterwards, I'd manually package the box and upload it. The result was my first base box, [Sgoettschkes/debian7](https://atlas.hashicorp.com/Sgoettschkes/boxes/debian7). I didn't really think about other users and updatet it from time to time, installing upgrades for all installed packages and maybe adding something I wanted to be present in the base box.

When switching from chef to Ansible for provisioning, using local Ansible provisioning rather then the Ansible provisioner from vagrant which needs Ansible present on the host, I also installed Ansible in the base box. My original idea was to remove chef because I don't use it anymore. Back then I realized there are a few people out there using my base box (it has ~400 downloads to date), which means removing the provisioner people rely upon is not the best idea.

I decided to split the boxes up, providing [Sgoettschkes/debian7-ansible](https://atlas.hashicorp.com/Sgoettschkes/boxes/debian7-ansible) which is, as you might have figured, the chef base box + my software selection and Ansible, as well as [Sgoettschkes/debian7-chef](https://atlas.hashicorp.com/Sgoettschkes/boxes/debian7-chef), which is the same but with chef instead of Ansible. The Sgoettschkes/debian7 box is deprecated now and won't receive any updates.

## Knowing what's inside

To find out what exactly is going on inside my base boxes, have a look at the git repository at GitHub, [Sgoettschkes/va](https://github.com/Sgoettschkes/va). It contains all three boxes. Looking into `debian7-ansible`, you'll see a very basic `Vagrantfile` and the provision.sh which contains all commands which are executed inside the vm before it's packaged and shipped.

It's not perfect and executing shell commands might not be the nicest way, but I really like that it just works. Again, I could try getting a real base box working with packer and maybe I will in the future. But for now, this works exactly like I need it. No need to make the setup more complicated!

If you are using my debian7 box, consider switching to either debian7-ansible or debian7-chef. It should not break anything as the software stack is nearly the same (although not installing chef means ruby is not up-to-date on the ansible base box). If you are not using any of my base boxes yet, you might want to reconsider. As you see, I really take care of maintaining stable base boxes and as they are lightweight, you can use them as a foundation to build your stuff on top.
