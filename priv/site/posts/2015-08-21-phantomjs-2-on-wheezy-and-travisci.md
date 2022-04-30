---
layout: _post.html.eex
category: dev
tags: [dev, phantomjs, testing, debian, wheezy, travisci, vagrant, dart]
title: "PhantomJS 2 on Wheezy and TravisCI"
author: Sebastian
date: 2015-08-21 20:40:00 UTC
permalink: p/phantomjs-2-on-wheezy-and-travisci.html
---
After playing with Dart for a little while, I also looked into testing with Dart and learned that the test library can use PhantomJS to test the code that interacts with the DOM. Being a testing junkie, I wanted to give this a try but learned that I needed PhantomJS 2 to get it working. Beside running it in my VM, I also wanted to have it running on TravisCI. This blog post tells you how to set up both.

## Compiling it yourself

I struggled to find a binary version of PhantomJS 2. This version was released on January, but there are problems regarding building the binaries to work on different systems. The contributors are working on a solution. Until then, you have to build PhantomJS 2 yourself.

There is a script for this and the build steps seem rather easy. I ran into problems doing this on my Debian Wheezy VM because of not enough RAM. So I spun up another one, gave it 2 GB of RAM and two processors and ran the script with `--jobs 2` which seemed to do the trick.

After 2 hours of obscure output, a shiny executable named `phantomjs` was there. I put it up to download so everybody running Debian Wheezy can use it. Due to static linking it might not work, but give it a try:

```
sudo apt-get install -y libicu52 libfontconfig1 libjpeg62 libpng12-0
sudo wget -O /usr/bin/phantomjs https://copy.com/YqL4Uc9T0PERoApf
sudo chmod +x /usr/bin/phantomjs
```

## Do it on TravisCI

After running the tests locally, you might wanna run them on your CI server as well. If you are using TravisCI, you might be surprised. Even though TravisCI has PhantomJS preinstalled, it's the 1.9.8 version.

Put this commands into your `install` or `pre_install` section to get PhantomJS working:

```
curl -s https://packagecloud.io/install/repositories/armando/phantomjs/script.deb.sh | sudo bash
sudo apt-get install phantomjs=2.0.0
```

Now the only problem is that the old PhantomJS is in the `PATH` before the /usr/bin. This means that `phantomjs` points to the old 1.9.8 version. My workaround for this is running the following command when running the Dart tests: `export PATH=/usr/bin:$PATH && pub run test -p phantomjs test/test_app.dart`. Maybe there is a nicer way. I though about removing the path to the old phantomjs executable from the `PATH` but could not find any easy way to do this. I also tried finding any settings for the dart test runner to tell him where to find the PhantomJS executable, but wasn't successfull.

With PhantomJS running locally and on TravisCI, you can go ahead and write tests for your Dart code. Happy testing!
