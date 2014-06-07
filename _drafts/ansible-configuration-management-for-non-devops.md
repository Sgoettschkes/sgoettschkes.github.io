---
layout: post
category: devops
tags: [devops, configuration management, sysadmin, ansible]
title: Ansible - Configuration management for Non-Devops
author: Sebastian
date: 2014-05-31 18:48:00 UTC
---
If you have worked with configuration management tools like Puppet or Chef in the past, you may have come to the conclusion that setting up servers automatically is like automating the build for your software. You are able to just set up new servers or rebuild the old ones without any hassle. All the little tweaks you make are documented in the configuration management tool and the evolution of your server is in git. Never again do you have to wonder how you configured nginx or what you did to get redis running like it is. Awesome!

I have worked with chef to manage 30 servers which were doing image processing. I have worked with puppet in a private setup where I had 2 AWS EC2 machines running. Between the two, I'd chose chef every day of the week. Writing ruby code just feels more natural to me. But when it comes to use one of these tools (or others like Salt) for smaller setups like your one virtual server at DigitalOcean or your Raspberry Pi, setting up a server feels like a major overhead.

## Just ssh into the box

Ansible takes another approach: It runs on your local machine and establishes a ssh connection to every host you want to provision, executing the commands you specified. This stateless approach means that other than chef, a client does not know he is managed by a tool and cannot ask the server for updates or specific values (like you could ask a chef server to tell you the IPs of all database servers). Running locally it also means that it's not suited for big setups, because two people executing ansible would result in possible messed up setups and errors are only available locally.

But this local execution is the thing I like about ansible when provisioning my Raspberry Pi or my virtual server. No setup other than on my laptop, no statefull server with much overhead. Just a file containing my hosts, the "playbooks" specifying what to execute, and you are good to go. I build a few shell scripts making it easier for me to bring my Pi from image to provisioned without me interacting.

## YAML

[Some people have a problem with ansible using YAML files](http://djwonk.tumblr.com/post/87548491694/what-if-ansible-used-xml-for-configuration-management) and while I also find it more pleasing to write ruby code I can certainly live with it. I also miss the easy only\_if and not\_if which chef provides to decide if one step is needed or not. And to make things worse the documentation of ansible is not good at all. After a bit of reading, I knew where to find the things I need in the chef documentation, but with ansible I am always searching but never finding. THe only exception are the modules, which are organized in a clean way.

While these are certainly issues, I 
