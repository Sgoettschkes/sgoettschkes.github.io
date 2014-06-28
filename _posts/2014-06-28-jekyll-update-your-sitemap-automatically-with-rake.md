---
layout: post
category: dev
tags: [dev, development, jekyll, rake, ruby, SEO, Google, Bing]
title: "Jekyll: Update your sitemap automatically with rake"
author: Sebastian
date: 2014-06-28 19:48:00 UTC
---
If you write your blog to also be found through Google, you may have a sitemap which makes it easy for Google and Bing to crawl your page. It might be good idea to inform both if this sitemap changes so they can send their crawlers your way and update their index with the great stuff you just put on their. This can be done by doing a `GET` request and passing the url to your sitemap as a parameter. Easy as pie, right?

## But my page is static

If you are running a wordpress blog or some other dynamic blogging engine, there is a chance that sending this request is either build in or available as a plugin. If not, you can always develop the parts yourself. But what if you are using Jekyll or another static blogging engine which doesn't execute any code on the server? Well, you can push the html to the webserver and then do a ping to google from your own laptop. That works with curl or wget or whatever you like.

To prevent you from forgetting to run the request and to always remember what the syntax is, you can always write a rake task which publishes your page and then pings Google and Bing. Let's do that!

## Start with something easy

**A short disclaimer before we begin: I copied most of the code from a blog post I cannot seem to find anymore and used it, so it's not my property. If you know who actually wrote this code, please tell me so I can give credit!**

First, let's tell Jekyll to generate the static files we need:

    desc "Generate blog files"
    task :generate do
        Jekyll::Site.new(Jekyll.configuration({
            "source"      => ".",
            "destination" => "_site"
        })).process
    end

That was easy. Running `rake generate` will now do the same as `jekyll build` but we can reuse it when we push our code to github (or any other git repository we have write access to). I am using github pages as an example where you put the HTML code into the master branch while the source for Jekyll lies within the source branch. So rake is creating a new repo within the `_site` directory, adding and commiting all files and then doing a `psuh force` to github:

    desc "Generate and publish blog to gh-pages"
    task :publish => [:generate] do
        Dir.mktmpdir do |tmp|
            cp_r "_site/.", tmp

            pwd = Dir.pwd
            Dir.chdir tmp

            system "git init"
            system "git add ."
            message = "Site updated at #{Time.now.utc}"
            system "git commit -m #{message.inspect}"
            system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
            system "git push origin master --force"

            Dir.chdir pwd
        end
    end

You can easily exchange that part for "just" a push to a remote repository or an rsync call to push the files to a remote location.

## Add some magic

And now let's add a rake task to ping Google and Bing about our new sitemap:

    desc "Push sitemap to Google and Bing"
    task :ping do
        urls = [
            "http://www.google.com/webmasters/tools/ping?sitemap=#{SITEMAP_PATH}",
            "http://www.bing.com/webmaster/ping.aspx?siteMap=#{SITEMAP_PATH}"]
        urls.each do |url|
            uri = URI.parse(url)
            req = Net::HTTP::Get.new(uri.to_s)
            res = Net::HTTP.start(uri.host, uri.port) { |http|
                http.request(req)
            }
        end
    end

The last part is calling the ping rake task from within the generate task which can be done with `Rake::Task["ping"].invoke`. Now, whenever calling `rake publish`, it generates the html, pushes it to github and pings Google and Bing. To see the end result, check out [my Rakefile](https://github.com/Sgoettschkes/sgoettschkes.github.io/commit/3e0de230b165591505b7496f9eb40103116967bc).

**Success!**
