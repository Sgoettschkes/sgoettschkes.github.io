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

## YAML and such

[Some people have a problem with ansible using YAML files](http://djwonk.tumblr.com/post/87548491694/what-if-ansible-used-xml-for-configuration-management) and while I also find it more pleasing to write ruby code I can certainly live with it. I also miss the easy only\_if and not\_if which chef provides to decide if one step is needed or not. And to make things worse the documentation of ansible is not good at all.

While these are certainly issues, not one peace of software is perfect and ansible does many things right. It's very easy to get started and doesn't enforce a certain architecture. The folder structure can be set up in any way, although keeping it close to the ansible way makes it easier to integrate certain parts. I also like the modules which are build in. Chef provides way less build-in functionality, leaving you to integrate cookbooks from third parties or writing your own. Checking if a cron job is in place or setting up a postgres database can be tricky with chef, but it's a delight with ansible. There are modules for this kind of stuff, so creating a postgres user is one line of YAML code and setting up a database is another line. It couldn't get any easier!

## Make a wish

If I could change one thing about ansible, it would be the documentation. It doesn't support learning ansible because the topics are to mixed and it also makes it hard to find certain information. That's not a good combination. The only exception are the modules, which are really good. One can find the module he's looking for and know how to do things in a short time. The thing missing there is the Inheritance, but that can be fixed easily.

## Take it for a test ride

As always, everybody should use the tools he likes best. For me, that's ansible for small setups simply because it's so easy. You should try it yourself. Having a repeatable setup for your server gives you the possibility to test something and then start all over again. 
