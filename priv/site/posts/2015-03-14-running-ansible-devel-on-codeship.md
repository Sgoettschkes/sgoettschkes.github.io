---
layout: _post.html.eex
category: dev
tags: [dev, ansible, codeship, debian, python, pip]
title: "Running Ansible devel (on Codeship)"
author: Sebastian
date: 2015-03-25 18:10:00 UTC
permalink: p/running-ansible-devel-on-codeship.html
---
If you are tasked with managing servers, you might have read about [Ansible](http://www.ansible.com/home). If you do not know it, here is a quick intro: With Ansible you can define tasks which should be run on your (remote) hosts and Ansible takes those tasks, opens a ssh connection into your hosts and executes them.

The tool is very flexible, making it possible to set up your remote hosts like you would with chef or puppet but can also be used to set up your Raspberry Pi, your Vagrant machines or your localhost!

I won't go into detail on how my Ansible playbooks look like. There are many tutorials about this out there.

## Working with Ansible

I started by installing Ansible through apt-get, because it's the easiest thing to do if you are running Debian or a Debian-based distro like Ubuntu. The version shipped is pretty old and I was stuck with Ansible 1.7, but then again I didn't need most of the new features.

I am using Ansible to install software on my localhost and Raspberry Pi as well as my private server. I also maintain 2 small virtual servers for my weekend project, [cllctr](https://cllctr.net). 

### Going bleeding edge

I had Ansible forked and cloned on my system for a long time because I did a tiny contribution to the docs some time ago. I still used the one from apt because I didn't really care for the new features. At AnsibleFest 2015, I heard the talks about 2.0 and what happens in the Ansible universe and I wanted to be a part of it.

I decided to run Ansible from devel (the master branch of the official repository).

Ansible is written in python, so if you got python installed, you'll need pip (the python package manager) and install some packages through pip which Ansible depends upon. Afterwards, cloning the Ansible repository and running the `hacking/env-setup` bash script is enough to get it working. The env-setup will change your `PATH` and add some environment variables but it's temporary, so make sure to put it in your `.bashrc` or somewhere so it's executed whenever you start a shell!

## Continuous Deployment for your infrastructure

Let's get back to my weekend project for a moment. I try to use best practice and try new things with cllctr even if they don't really make sense for a weekend project. The code is deployed using [Codeship](https://codeship.com/) whenever I push a new commit. Depending on the branch, it's deployed to a staging or production environment.

I wanted to do the same with my Ansible run because it makes sure my code is always runable and the everbody with write access to the repo can deploy the infrastructure. Defining the environment needed to do an Ansible run and having the steps written down makes it possible to set up his own environment with a detailed and correct manual.

Codeship makes this really easy. Pip is already there, so installing Ansible with pip is a one-command thing and setting up the `ansible-playbook` command as the deployment command is easy as well. The only thing is the need for Codeship to be able to ssh into the servers, but with the Codeship ssh key for your projects, that's easily done as well!

## Ansible devel at Codeship

For a while, my local Ansible was always up-to-date and Codeship ran the 1.8.4 version available through pip at that time. It was fine as I didn't use any features not available in 1.8.4 and didn't hit any bugs. 

But a few weeks ago, I had a specific use case and because I could not solve it myself, I asked the mailing list. An hour later Brian Coca opened a pull request to add the functionality I needed. I was stunned. The only problem: I was not able to use it as it was not merged into the devel branch yet.

I decided to use my own fork of Ansible to run locally. This meant that I could apply the PR from Brian on my fork and use it even though the upstream repository didn't had it merged yet. It worked like a charm and I was able to test the PR and confirm it works as expected.

Now the only problem was using this specific version of Ansible at Codeship. This - again - was easier than expected. Cloning my repo and running it turned out to be a 5 minute change. One upsite to this is that because I use my own fork of Ansible, I have full control over changes done to the devel branch. This means I can pull in upstream changes from time to time, test them locally and push them to my fork.

If you use the Ansible repo directly on a service like Codeship, it might pull in a different version on every run, leaving the possibility of unexpected breaks. If you don't want to maintain your own fork, you can of course checkout a specific commit SHA or tag and "pin" your Ansible version that way!

## Learnings

After getting Ansible running from devel I felt stupid for not doing it earlier. If you like using bleeding edge software, give it a try! Using the same version everywhere is almost a must if you want to avoid failing ansible runs. If you got Co-Workers running ansible as well, bleeding edge might not be the right way.

But if you got the freedom to experiment, do it. I didn't regret it one bit!
