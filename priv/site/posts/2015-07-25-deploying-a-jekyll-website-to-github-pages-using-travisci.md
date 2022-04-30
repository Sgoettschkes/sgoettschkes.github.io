---
layout: _post.html.eex
category: dev
tags: [dev, blogging, Jekyll, Github Pages, TravisCI]
title: "Deploying a Jekyll website to Github Pages using TravisCI"
author: Sebastian
date: 2015-07-25 22:15:00 UTC
permalink: p/deploying-a-jekyll-website-to-github-pages-using-travisci.html
---
Today I switched over this blog to be subject to continous deployment. Whenever I push a new commit (which might be a design change, new blog post like this or some small change), everything is build and automatically pushed to Github Pages, which host this blog.

Let me tell you how I did it!

## What?

This blog is served as static pages, meaning only HTML, CSS and Javascript are stored on the servers. There is no application in the background, getting the blog posts out of a database like Wordpress does it. Everything is written in text files which are then used to generate HTML. The software I use is [Jekyll](http://jekyllrb.com/). Because it's only HTML, I can host it almost everywhere and I chose Github Pages because the repository is already on github and it works really great.

There is a way to get around building the static website locally: [Github Pages](https://pages.github.com/) can run Jekyll in the back, generating the pages for you. The drawback is that you can't use Jekyll plugins, which means it's limited to the things Jekyll can do out of the box. This is why I build the pages locally and then push the result to Github, letting Github Pages serve the static HTML.

And then there is [TravisCI](https://travis-ci.org/), which is a Continous Integration service "in the cloud", meaning you don't have to run anything locally. It executes your tests and can also deploy your code. It's free for repositories hosted on Github which are public, so it's a perfect choice for me!

Please note that this is not a beginners tutorial on Jekyll, Github Pages or TravisCI. It's a description on how to connect those three, so you should either have Jekyll running on Github Pages already or pick the things needed up on the way. I won't go into detail on that!

## Why?

Up until now, I had to run commands locally to build the static pages and then push the stuff to github so it can be served. This meant I had to have Jekyll installed locally, all the right gems in place and needed to remember which commands to execute.

It also meant I couldn't just clone the repo on some other PC, change some files and be done. I had to either install everything locally or use vagrant with it's dependencies. That's way to much overhead for quickly fixing a typo! And I could not use the github web interface to change stuff directly. I could change it, then update my local repository when I get home, build the page and upload it again. What a hassle!

## How?

Let's get started! Let me explain my end result briefly: If I changed something in some file and push the resulting commits, TravisCI generates the whole static page using Jekyll and then pushes these changes to the Github Pages branch (usually `gh-pages` or `master`). The whole Jekyll setup lives in a different branch.

For this post, I'll assume your Github Pages branch is `master` and the branch the Jekyll setup lives in is `source`. This is the setup of my blog as well. I am using rake to put together my tasks and my Rakefile looks something like this:

```
require "jekyll"
require "tmpdir"

GITHUB_REPONAME = "sgoettschkes/sgoettschkes.github.io"
GITHUB_REMOTE = "https://#{ENV['GH_TOKEN']}@github.com/#{GITHUB_REPONAME}"

desc "Generate blog files"
task :generate do
    Jekyll::Site.new(Jekyll.configuration({
        "source"      => ".",
        "destination" => "_site"
    })).process
end

desc "Generate and publish blog to gh-pages"
task :publish => [:generate] do
    fail "Not on Travis" if "#{ENV['TRAVIS']}" != "true"

    Dir.mktmpdir do |tmp|
        cp_r "_site/.", tmp

        Dir.chdir tmp

        system "git init"
        system "git config user.name 'Sebastian Göttschkes'"
        system "git config user.email 'sebastian.goettschkes@googlemail.com'"

        system "git add ."
        message = "Site updated at #{Time.now.utc}"
        system "git commit -m #{message.inspect}"
        system "git remote add origin #{GITHUB_REMOTE}"
        system "git push --force origin master"
    end
end
```

What's going on? Well, we have the `generate` command which runs a Jekyll build and stores the static website into the `_site` folder. The `publish` tasks fails if it isn't run on TravisCI, creates a temporary dir and copies everything from `_site` in there. It then makes this temporary dir a github repository, adds all content, commits it and pushes it to github into the master branch. As this would overwrite previous commits, `--force` is needed. This means the master branch has only one commit at any time. It's a workaround, but it works pretty well for me. The history is in the source branch, which is all I need.

If you look closely, you'll see `#{ENV['GH_TOKEN']}` in the `GITHUB_REMOTE` variable. It holds the Github token which let you deploy without using a ssh key. To get this variable filled, we need to put it into our `.travis.yml`. Putting it there in plain text would mean everybody with read access to our repo could push code just like TravisCI does. Which means we need to encrypt it!

But first, let's look at the `.travis.yml` file:

```yaml
language: ruby
sudo: false
branches:
    only:
        - source
rvm:
    - 2.1.5
install:
    - gem install --no-rdoc --no-ri bundler jekyll rake
script:
    - rake generate
after_success:
    - rake publish
```

This file tells TravisCI to have ruby installed, only build the source branch, use ruby 2.1.5, install bundler, jekyll and rake before running `rake generate`. If this command returns error code 0, it will run `rake publish`.

The missing part is the environment variable from above, containing our token. First, install the "travis" gem using `gem install travis`. Then query the Github API for your token:

```
curl -u <USERNAME> \
    -d '{"scopes":["public_repo"],"note":"CI: <REPONAME>"}' \
    https://api.github.com/authorizations
```

Don't forget to replace your username and the reponame! The response should include a key called "oken" which holds your token. The last step is encrypting it and adding it to the `.travis.yml` file. The travis gem can do this for you. From your repository root, run `travis encrypt --add 'GH_TOKEN=<TOKEN>'`. The gem adds the encrypted value directly to your file!

After enabling the build process on the TravisCI website, push your changes and see if everything works out!

## What's next?

With TravisCI enabled, you could add linters for Markdown, CSS and javascript as well as a javascript test framework if you'd like. Just add the commands to be run to your `.travis.yml` file and before pushing your updated version, Travis will look if everything still works.
