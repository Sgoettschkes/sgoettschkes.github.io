---
layout: _post.html.eex
category: dev
tags: [dev, php, symfony, mongodb, redis, foundation, jquery, vagrant, ansible, github, codeship]
title: "Developing cllctr"
author: Sebastian
date: 2015-01-18 21:40:00 UTC
permalink: p/developing-cllctr.html
---
Over the past two month, I have been building a new weekend project: [cllctr](http://cllctr.net). It's a CD database you can use to store information about your CDs. Say goodbye to excel lists and over-the-top stuff as [discogs](http://www.discogs.com/) or [collectorz](http://www.collectorz.com/). cllctr is focused on the right amount of data, balancing the time needed to enter new CDs or organize a exisiting collection.

Currently, cllctr is more or less just a few pages where you can add/edit a CD and view a list of all your CDs. With time, the list of features will grow for sure. I have a ton of them in my head and only need some time ;)

In this blog post, I'd like to focus on the technical details of cllctr. How did I build it, why did I choose to do things they way I did and so on.

## On the shoulder of giants

The backend is written in [PHP](http://php.net/) and [php-fpm](http://php-fpm.org/) is used together with [Nginx](http://nginx.org/) to serve the webpages. [MongoDB](https://www.mongodb.org/) takes care of persisting the data and [redis](http://redis.io/) is used to store sessions as well as some calculated data like the amount of CDs somebody has.

### Backend matters

[symfony2](http://symfony.com/) is my web framework of choice. It is using stuff like [monolog](https://github.com/Seldaek/monolog) for logging or [swiftmailer](http://swiftmailer.org/) to send out emails, which comes in handy because it's both very flexible yet easy to handle.

To ensure code quality, a collection of tools like [phplint](http://www.icosaedro.it/phplint/), [phploc](https://github.com/sebastianbergmann/phploc), [security-checker](https://security.sensiolabs.org/), [phpmd](http://phpmd.org/), [pdepend](http://pdepend.org/), [phpcpd](https://github.com/sebastianbergmann/phpcpd), [php_codesniffer](http://www.squizlabs.com/php-codesniffer) and [phpunit](https://phpunit.de) are used. [phing](http://www.phing.info/) is the build tool in place, making it easy to run all those tools at once. All those tools can be run by executing the test target with phing. It stops if any of those tools reports any problems. I have even written my own little bash script which counts the amount of "TODO" comments and if it's over 15, fails. This makes it easy to spot problems in the code. It's not perfect though as every tool has it's own settings and something fails because of wrong settings. Some tools report data which cannot be interpreted by the software itself (like phploc or pdepend) but must be checked by a developer.

Phing also takes care of building and updating the whole application. It can update the database to ensure indexes and unique fields, clear the cache and has some targets for development (like adding test data). Everything is designed to be easily run by anybody working on the project. As the only developer it's hard to say if the goal of "runs without any hassle" is really achieved, but it sure feels like it.

### Frontend goodies

To make the webpage responsive, I am using the [foundation](http://foundation.zurb.com/) framework. It comes with [jQuery](http://jquery.com/), so this is what I am currently using for the (limit amount of) javascript code. I'll definitely switch to something more elaborate in the future if the frontend code gets more. Foundation is written in [Sass](http://sass-lang.com/) which is what I am using for Css as well.

To compile Sass to Css, combine/minify the javascript code and optimize the pictures, [grunt](http://gruntjs.com/) is used. It's way better for these frontend stuff than Phing is and even if I don't like having two build tools, it works great. [Npm](https://www.npmjs.com/) is used to install grunt and it's plugins as well as Sass. To install foundation, [bower](http://bower.io/) is used. There is currently no good alternative to this way and although this means there are three package manages involved, it works ok. I'd love to see npm being able to install bower packages as well!

Grunt takes the foundation code installed through bower, runs it through sass to produce css and through [uglifyjs](https://github.com/mishoo/UglifyJS2) to produce the js. For image, I am using the [imagemin](https://github.com/gruntjs/grunt-contrib-imagemin) plugin for grunt which uses many different tools to minify images and place them in the public folder of the webapp.

### All things DevOps

To develop cllctr, I am using a [vagrant](https://www.vagrantup.com/) vm. Everything is setup so that checking out the code (which lives on [GitHub](https://github.com/)) and running `vagrant up` is all you need to do to run the application locally (Of course there must be vagrant and [virtualbox](http://virtualbox.org/) installed). The provisioning of the vm is done with [Ansible](http://www.ansible.com/home), my new favourite orchestration tool.

If new code is pushed to GitHub, it's automatically checked out by [Codeship](https://codeship.com). The project is build inside a Codeship vm, the phing test target is run and if everything is green, the project is deployed using [rsync](https://rsync.samba.org/).

The deploy targets are servers running at [DigitalOcean](https://www.digitalocean.com/?refcode=5cc7357e2a20). There are currently two of them, one for staging and one for production. Both host the webserver, application and databases. Codeship deployes the code depending on the branch it lives in. The `develop` branch is deployed to the staging server and the `master` branch is deployed to production.

The DigitalOcean droplets are managed by Ansible as well. A Ansible run configures a staging or production server so he's ready to receive the code to run the application. The Ansible code lives on GitHub as well and is run by Codeship. The way it works is the same as for the application: If new code is pushed to the `develop` branch of that repository, an Ansible run with the staging server is done. For the `master` branch the same run is done, only this time for the production server.

To monitor the servers, I have set up [Monitority](http://monitority.com/) which pings them every now and then. To check the performance, I am using [WebPageTest](http://www.webpagetest.org/). The domain name and DNS are from [NameCheap](http://namecheap.com/).

## Mindset

When I started with cllctr, my goal was to build something useful. I also wanted to make sure to use a mixture between stuff I know (symfony, Sass + foundation, jQuery, Vagrant) but also dive into new stuff (Ansible to some extend, npm/Grunt/bower, Continuous Deployment/codeship). This currently makes sure I am moving forward but also feeling challenged.

I started by quickly getting something ready which could be used. It wasn't pretty, it wasn't well tested, the Phing setup wasn't really there yet, and deployment wasn't possible. Then I stopped adding functionality and got all those ready. I made sure tests where run pretty early (The first commit to the cllctr repo was on November 20th, the first test run on Codeship only 4 days later). For every feature I added I also made some other code nice. I wrote down areas I want to improve and followed up on these plans.

I also did things the easiest way possible. Just implement it so it works. Afterwards, refactor it to adhere to coding standards, best practices and so on. One example where my tests. For the functional tests, I had a phing target which set up the database and one that ran phpunit which depended upon those database setup. All tests then used this one database setup. So tests where not really seperated and I had to work around some things, but it worked. A week ago or so I refactored it in a way that each functional test sets up a database to use, so each test is really isolated now.

## Stuff to improve

Of course I am not done. While adding new features and making cllctr nicer, I also want to improve in some areas. The tests clearly need some work. Some things are not tested at all, some are functional tests because I wasn't able to mock some symfony internals.

Deployment with rsync works, but is not resilient enough. If rsync has a problem in the middle of a deployment, half the code is from the new version and half the code is from the old version. There are tools out there like [capistrano](http://capistranorb.com/)/[capifony](http://capifony.org/), [fabric](http://www.fabfile.org/) and others which can be used to deploy code into production. I'll definitly have a look at them!

There currently are no backups done on the production server. It's ok for now as the software is alpha and if the server really dies, than so be it. But for the near future backups should be done and restoring of those backups should be tested. I wrote about this topic and a setup I had for another project which automatically downloaded backups from [S3](http://aws.amazon.com/s3/), loaded them locally and ran some tests. I'd like to set something like this up once again because it's really awesome to know your backups are working at the end of a script run.

I'd also like to get monitoring up and running. Especially log file monitoring is not done at all. I get emailed the errors that are happening, but I feel there are better ways especially to see if e.g. 404s are hit more often than usual. Such errors can go unnoticed for very long!

And of course it would be cool to try new things, like adding SSL (never done that before), using more web servers with load balancing, scaling the database servers. But for this to be justified, there need to be a big user base.

## Try it!

If you are collecting CDs, please give [cllctr](http://cllctr.net) a try. [Tell me](mailto:sebastian.goettschkes@googlemail.com) what you like and what features you want to see. I'd love to chat about it and improve cllctr together with the people using it.
