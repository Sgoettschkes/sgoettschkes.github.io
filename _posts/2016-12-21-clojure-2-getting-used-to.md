---
layout: post
category: dev
tags: [clojure, leiningen, vim, atom, vagrant, adventofcode, projecteuler]
title: "(clojure 2) Getting used to"
author: Sebastian
date: 2016-12-21 10:00:00
---
After "[The setup](http://sgoettschkes.me/p/clojure-0-the-setup.html)" and "[The beginning](http://sgoettschkes.me/p/clojure-1-the-beginning.html)", my time with Clojure was somewhat limited due to pre-christmas stress. But this gave me time to reflect on what I learned so far, what I liked and didn't like. I also attended the December Meetup by [(clojure 'vienna)](https://www.meetup.com/clojure-vienna/) and pair programmed Clojure for a few hours.

## The ecosystem

I already said I liked the way Leiningen worked. Nothing has changed here. Leiningen feels stable and works great. I didn't come across any issues using it, which is a great way for a language to work.

I didn't find an editor/IDE I liked yet. I started with vim because it is what I know and universal enough. I also set up [Atom](https://atom.io/) and use it but don't really like it. My biggest problem right now is that Clojure and Leiningen are installed inside a virtual machine, making many tools unusable. I'd love to be able to evaluate statements from my editor directly by running them inside the vm but it turns out that's a bit of a problem. There are tools to do that, but the setup needed is just to much.

My current workflow is writing code in Atom, running it sshd into the vm and also having an additional ssh session running with the Leiningen repl started to test out different things.

## The workflow

Programming in a functional lanuage is just different then using a procedural language. It's more about passing data around and rearrange it instead of maintaining a global state. It's true that it's much easier to reason about a small part of the software as the input and output is defined and can be tested.

When pairing on Day 9 of Advent of Code, my coding partner who is also new to Clojure mentioned that he can't see himself working in the language due to this being so different than what he's used to from other languages (mainly Java). While I understand what he means I honestly think that it's not better or worse but different. It takes time to get used to it.

One thing I noticed was that testing was very easy because you can always split up big function into smaller ones, making them easily testable. It was also easy to reason about the different parts. The only hard thing was to put together the plan on how to get started and which path to take. But this discussion was useful and it was good to have it in the beginning instead of moving along and "just doing things".

## The current status

The last weeks have been busy, so I didn't dive deeper into Clojure. My next step is taking a book and working through it while on christmas holiday. After using Clojure in practice and learning a ton I feel like a bit more theoretical understanding would be good at this point.

I'd also like to write a small app in Clojure to see what this feels like. Advent of Code, Project Euler and others are great but they don't mimic the real world. I realized with Advent of Code that I spent most of the time figuring out the algorithm, which does not help me getting any further with Clojure.

## The meta

Beside working with Clojure, I also watched a few talks by Rich Hickey. I like his ideas and got the feeling his one of those people not buying into hype and "best practice" but asking hard questions and thinking for himself. I might not agree with everything he says and don't agree with every decision in Clojure, but overall he seems very reasonable. That's more than enough for me to get behind Clojure.

The next update will most likely on the book I chose to work through and what I learned. And it might only get here after my holiday, so enjoy the holidays, relax and stay tuned :)
