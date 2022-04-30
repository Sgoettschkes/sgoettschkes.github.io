---
layout: _post.html.eex
category: dev
tags: [Dev, Python, iPython, Jupyter, Google App Engine, API]
title: "Google App Engine Remote API within iPython Notebooks"
author: Sebastian
date: 2015-12-11 09:45:00 UTC
permalink: p/google-app-engine-remote-api-within-ipython-notebooks.html
---
At [blossom](https://www.blossom.co), we are running on [Google App Engine](https://cloud.google.com/appengine/) (GAE). It's nice to stand on the shoulder of giants and don't have to worry about servers at all. GAE takes care of scaling up and down for us, handles our database as well as storage and gives us great insight into our production environment.

One thing I don't like about GAE is that in order to have a look at the data inside our production database, you'll either use the web interface or a REPL (which is called `remote_api_shell`). The web interface just doesn't cut it if you want to look at different tables, compare data and do things like "Give me all projects and tasks for this set of users". With the `remote_api_shell`, you can do that but it's fairly limited in terms of repeating things and sharing your results.

## Python in your browser

For learning Python and testing solutions, I am usually running an [iPython](https://ipython.org/) kernel within [Jupyter](https://jupyter.org/). If you don't know about the Jupyter project yet, go check it out! It's a server running on your localhost which serves a web frontend where you can create so-called notebooks and write code in various languages (depending which Jupyter kernels you have installed) right inside your browser. The code is executed through the server on your localhost, so it's the real deal and not some Javascript library with an incomplete feature-set.

With a Juypter server running and the iPython kernel installed, I can set up new notebooks to play around with e.g. RegEx. It's also fairly easy to do some tutorial or see how, for example, generators work. Notebooks get stored on my machine, meaning I can pick up where I left whenever I want. Changing code, re-executing it and copying it is also super easy. And if I want to share the notebook, I can export it to HTML, markdown and even pdf.

## Combining the GAE Remote API with iPython notebooks

It became clear to me pretty fast that by using an iPython notebook to connect to the GAE Remote API and then working with objects like I do in the code could make things much easier. Sadly, I wasn't able to pull it off as I hit more than one wall trying to get the environment set up the right way. With some luck, I found a post by [Andrey](http://anfedorov.com/) where he stated that he got this setup working. I shot him an email and he was very helpful and we got two different solutions working within a few emails.

It works pretty straight forward: When the iPython kernel boots, it looks for files to execute in a specific startup folder at `~/.ipython/default_profile/startup`. Putting a `startup.py` file there which provides a function to connect to the GAE Remote API is the only thing needed:

<script src="https://gist.github.com/Sgoettschkes/5e9cae762530e53d0971.js"></script>

This makes it possible that within a notebook, you call the function `connect_to_gae()` and you are able to work with your objects or GQL just as you would inside your project:

```
connect_to_gae()

from models import User
User.query().get()

from google.appengine.ext import ndb
ndb.gql("SELECT * FROM Project where __key__ = KEY('Project', 'somekey')").fetch()
```

For details about the implementation, have a look at the GIST. It's pretty weird in the way that you have to add and remove stuff from the sys.path before being able to actually call the functions that establish the connection. By wrapping all this into a function, I make sure it's only invoked when needed. Other notebooks that are not intended to work with the GAE Remote API won't work any different!

The `startup.py` file for blossom has a few additional lines which include our project in the path so I can import our models and work with them easily. You can also add common imports there or provide helper functions you need a lot in your notebooks.

With this setup, I was able to do some analysis on our database, got it formatted nicely and shared the HTML with my co-workers with ease. And by providing them the notebook itself, they can modify my work and put their own on top, making collaboration totally easy!
