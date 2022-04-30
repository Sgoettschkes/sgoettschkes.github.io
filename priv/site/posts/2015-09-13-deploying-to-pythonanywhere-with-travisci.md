---
layout: _post.html.eex
category: dev
tags: [dev, python, pythonanywhere, travisci]
title: "Deploying to PythonAnywhere with TravisCI"
author: Sebastian
date: 2015-09-13 20:50:00 UTC
permalink: p/deploying-to-pythonanywhere-with-travisci.html
---
Many of you might already know it: Soon I'll be joining the [blossom](https://www.blossom.co/) Team on their quest to project management awesomeness. The current development stack of blossom consists of Python and Dart running on Google App Engine. In order to get some experience with both Python and Dart, I started a small side project which is a perfect combination of my two main interests, development and music.

## The project

The project is a [small webpage](http://www.tbalive.at). To be honest, it could be done with wordpress or tumblr way easier! But developing it manually I can dive into Python and Dart all while working on something usefull. The alternative would be to setup the webpage with one of the systems named above and then work on some example code to learn Python and Dart, which doesn't sound fun.

I created a Flask app which has some routes. It reads some data from csv (no database at this point) and then renders some lists out of this data. I added tests for both the data extraction and the routes as well as pylint to check my codestyle.

To filter a few lists I added a little bit of dart code. It's compiled to js using dart2js. There is also stylus as a css preprocessor. For testing the Dart code I added PhantomJs to the setup but only use it to check one dart method right now.

### Continous Integration

As a first step, I set up Continous Integration with [TravisCI](https://travis-ci.org/). The service gets triggered when I push commits to GitHub, checks them out and runs my tests. It's pretty good to get feedback if something fails. I set TravisCI up to test both Python 2.7 and PyPy as well as Dart stable and unstable. I wasn't able to get invoke running with Python 3 which is why I don't test it.

Getting it running was a bit of a hassle because Dart needs to be installed by hand. There is also the need to install PhantomJS 2.0 because TravisCI only has 1.9 installed.

### Adding PythonAnywhere to the setup

I chose [PythonAnywhere](https://www.pythonanywhere.com) because I liked the idea of having a PaaS which focuses on Python. I could have gone with Heroku or any other PaaS offering Python support. I didn't do extensive research so your views might vary, but I had the feeling that for Python specifically, PythonAnywhere looked like the best provider from the outside. And I am pretty happy with it right now.

After reviewing the options to deploy code to PythonAnywhere, I opted for rsync. It can be done over ssh to simplify authentication. After generating a ssh key pair and adding the public key to my PythonAnywhere container, I decrypted the private key file with the travis gem and added the decrypted file together with the public key to the repo.

For the deployment to work, I added a "script" deployment and made a deploy script which encrypts the private key, moves both keys to the `~/.ssh` folder, executes the rsync command and runs `pip install` on PythonAnywhere. The last step for the script is to `touch` the wsgi file so the web worker is restarted.

In the end, everything was pretty straightforward and easy. It took some trying out a few things as there are no guides out there.

In the end, everything was pretty straightforward and easy. It took some trying out a few things as there are no guides out there.

If you wanna dive into the code I am using, have a look at [tbalive/website](https://github.com/tbalive/website/tree/442ae0eae0a61583eeabce22f654aa21ca18e686) on GitHub. If you need help setting it up, get in touch!
