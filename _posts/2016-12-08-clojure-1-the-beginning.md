---
layout: post
category: dev
tags: [clojure, leiningen, vagrant, adventofcode]
title: "(clojure 1) The beginning"
author: Sebastian
date: 2016-12-08 20:00:00
---
After "[The setup](http://sgoettschkes.me/p/clojure-0-the-setup.html)", I dove right into Clojure. As said before, I want to get to know Clojure by working on [Advent of Code](http://adventofcode.com/) (AoC). I realize that coding puzzles and dojos and katas are not real world applications and one might miss certain things like performance or running an application in production. But they are small enough to provide fast feedback and to not hit a big wall. Even if I am not able to solve one, I can always skip that and keep going with another puzzle.

## lein run & lein test

Before starting with real code, I created a project for AoC. `lein new adventofcode`, ran in the `/vagrant` folder inside my Vagrant vm created a scaffold of a Clojure project the way Leiningen decided it should be. Within this directory, the program can be run by `lein run` and tested with `lein test`.

I was again surprised by how easy this was. Everything works out of the box, no changes needed. The test fails, but that's expected.

And if you want to play with Clojure a bit before writing real code, a quick `lein repl` brings up a nice repl you can use to get a feeling for the syntax.

## Advent of Code, Day 1

Right after that first few minutes, I got into the code. Looking at the first day of AoC, it seemed plausible to see if I could get the input for the puzzle by downloading the file. A quick google search later it seemed fairly easy: Add a dependency to the code, use the library to request a url and get a string back. Adding the dependency is one line in the `project.cls`, requiring it is one more line and doing the request is again one line. That's three lines. I was hooked!

Leiningen detects changes in the dependencies and downloads everything automatically once you run `lein run` or any other Leiningen command. I added all my code to the `core.clj` file because I didn't want to figure out how to best distribute code between many files. I usually focus on one thing at a time when learning a new language!

Sadly, my code didn't work. The reason was that the puzzle input needs login. I quickly decided that this would be to much of a hassle and put the puzzle input into a local txt file. Reading this file, I found the `slurp` function available in the clojure core which reads a file to a string. Again, very easy. It would be a problem with very big files but for now this was fine.

Solving the first day was a succession of this steps: Google for an isolated problem, find a function or way to solve it, continue.

## Error messages

While solving the first day, it became clear to me that Clojure error messages are horrible. Seriously, the are the worst messages I have ever seen. Usually, they are just a Stack Trace from an Exception. Sometimes, they point to a specific line somehwere in there and sometimes it doesn't even mention your code at all.

It took way longer than needed because I had a weird error I couldn't solve because I had no idea where to look. I looked at every piece of the code and after I already though the compiler was wrong I found the tiny little error.

A lot fo errors are EOF problems because on of the many closing paranthesis is missing. Again, there is no real hint where this is so you again are on your own counting paranthesis.

## Done

It took me maybe 3 hours to get both parts of the puzzle for day 1. Given Clojure is a completly new language for me and I had a few problems along the way, I guess this is an ok time spawn. I had a misunderstanding in the puzzle which took some time as well, so overall I was pretty happy.

I'll keep my impressions of the language for now and will get into them when I'm a little further down the road!
