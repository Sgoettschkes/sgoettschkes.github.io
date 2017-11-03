---
layout: post
category: dev
tags: [clojure, clojurescript, compojure, figwheel, garden]
title: "Quickstart guide for clojure (compojure), clojurescript (figwheel), garden"
author: Sebastian
date: 2017-11-03 14:00:00
---
Setting up new projects is always exciting, but if you have done it a few times, it's getting old quick. I have set up a few projects in the last time and I believe I have a nice setup going which I'm about to share with everybody interested. There is nothing new in here and if you are a seasoned Clojure developer, you might not learn much. If you are just starting out or have some work done in Clojure but need a working setup or some input on your current setup, you are at the right place.

All my projects live insight Vagrant virtual machines. I'll be using Clojure with Compojure and Ring, Clojurescript with figwheel and garden. I'm also throwing in the cooper library.

## Clojure

All my web Clojure projects include `compojure` and the `lein-ring` plugin. Both are mature and work very well, so I didn't look any further. My project.clj at this point looks like:

```
(defproject mycompany/myproject "0.1.0"
  :dependencies [[compojure "1.6.0"]
                 [org.clojure/clojure "1.8.0"]]
  :main myproject.core
  :min-lein-version "2.0.0"
  :plugins [[lein-ring "0.12.1"]]
  :ring {:auto-reload? true
         :handler myproject.core/app
         :open-browser? false
         :reload-paths ["src/" "resources/"]}
  :source-paths ["src/clj"])
```

The ring setup is important as it allows for auto-recompiling when run through `lein ring server`. `open-browser` is there because I run the project inside a vm, so there is no browser to open and instead of remembering to run `lein ring server-headless` every time, I disable it altogether.

# ClojureScript

Adding Clojurescript is just a dependency away, especially if you don't start with figwheel and other libraries but keep it plain and simple:

```
(defproject mycompany/myproject "0.1.0"
  :cljsbuild {:builds [{:source-paths ["src/cljs"]
                        :compiler {:optimizations :whitespace
                                   :output-to "resources/public/js/main.js"
                                   :output-dir "resources/public/js"}}]}
  :dependencies [[compojure "1.6.0"]
                 [org.clojure/clojure "1.8.0"]
                 [org.clojure/clojurescript "1.9.946"]
                 [ring/ring-core "1.6.2"]
                 [selmer "1.11.2"]]
  :main myproject.core
  :min-lein-version "2.0.0"
  :plugins [[lein-cljsbuild "1.1.7"]
            [lein-ring "0.12.1"]]
  :resource-paths ["resources"]
  :ring {:auto-reload? true
         :handler myproject.core/app
         :open-browser? false
         :reload-paths ["src/" "resources/"]}
  :source-paths ["src/clj"])
```

`lein-cljsbuild` helps transpiling ClojureScript to Javascript by running `lein cljsbuild once` or `lein cljsbuild auto`.

## Garden

I usually try to stick with the choices popular within the ecosystem. I have used Sass and Less in the past and was fine with both. Garden is another CSS precompiler, but you write your CC as Clojure data structures, making it easy to integrate it within the ecosystem. There is nothing wrong with using another precompiler for CSS or write plain CSS if the project calls for it.

For garden, you only need the dependency `[garden "1.3.3"]` as well as the plugin `[lein-garden "0.3.0"]`. After that, adding the garden config to your project.clj works like this:

```
  :garden {:builds [{:id "screen"
                     :source-paths ["src/garden"]
                     :stylesheet myproject.core/main
                     :compiler {:output-to "resources/public/css/main.css"
                                :pretty-print? false}}]}
```

As you can see, the garden source code goes into `src/garden`. Within `src`, there is also `clj` and `cljs` to split up the different parts (backend, frontend, CSS).

## Figwheel

We glanced over figwheel when setting up ClojureScript. If you would stop right now and would start working on your project, you'd need to wait for the ClojureScript compiler to generate the js on every change, than reload the website, navigate where you left of and look at your changed.

With figwheel, only the part of your ClojureScript app that changed get recompiled and these parts get pushed to the browser directly which in turns exchanges the code parts so you see the changes directly.

With all this going on, figwheel was the first hurdle for me. Adding it was straightforward by adding `[lein-figwheel "0.5.14"]` to the plugin section of the project.clj. After the, the `cljsbuild` config needed to be changed:

```
  :cljsbuild {:builds [{:compiler {:asset-path "js/out"
                                   :main "myproject.core"
                                   :optimizations :none
                                   :output-to "resources/public/js/main.js"
                                   :output-dir "resources/public/js/out"}
                        :figwheel {:websocket-host "myproject.local"}
                        :id "dev"
                        :source-paths ["src/cljs"]}]}
```

The `websocket-host` was needed because of the vm. I run the project through a hostname and not by mapping localhost ports. The second thing needed was the figwheel config itself:

```
  :figwheel {:css-dirs ["resources/public/css"]
             :hawk-options {:watcher :polling}
             :ring-handler myproject.core/app
             :server-port 3000}
```

`css-dirs` is important to have hot code reloading for CSS as well. The `hawk-options` is needed because of the vm (again), as figwheel does not detect code changes (due to the way Vagrant mounts folders). By adding the `ring-handler`, the ring server is run when running figwheel, making it easier than running both processes in parallel.

## Bonus points: Cooper

The next thing for me was to not have the need to run both `lein figwheel` and `lein garden auto` in two different shells. Luckily, there is `cooper`, which can be used to run many tasks in parallel. Add the lein plugin and a small config, and you are good to go:

```
  :cooper {"figwheel"  ["lein" "figwheel"]
           "garden" ["lein" "garden" "auto"]}
```

After that, `lein cooper figwheel garden` got you covered.

## Follow along

If you want to see this changes in full (without cooper right now), go over to [https://github.com/Sgoettschkes/web-clj](https://github.com/Sgoettschkes/web-clj) and step through the commits. You can see every code change in detail much better than I would ever be able to outline in this blog.

I'll also be adding more (and writing a second blog post) on testing Clojure and ClojureScript as well as adding some example code to the repo. Stay tuned!

I'm also looking for feedback towards my setup, both in terms if libraries I used and the ways I plugged them together. You can either comment here, add an issue to the github repo or find me on social media as well as send me an email.
