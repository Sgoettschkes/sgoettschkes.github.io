---
layout: post
category: tools
tags: [tools, backup, obnam, data recovery]
title: Backups with Obnam
author: Sebastian
date: 2014-05-31 18:48:00 UTC
---
You know you should do backups, right? Taking all those data you store on your laptop and put it somewhere safe. There are so many ways of doing backups but people still don't do regular backups. Maybe you put the data on an external drive and swear you'll do this every month from now on. Chances are you'll be to busy next month and the month after. And you still got a backup, right?

I was like this. I wrote done a plan when to backup on an external drive and even to DVDs, what to backup and in which intervals. It was a great plan. But it didn't take into account that when the time comes to sit down and do the backup, other things are more important. Because there is still the last backup, right. And how often does the hard drive die after all! And there don't have been that many changes to the data I want to backup, so it doesn't make sense.

## Obnam to the rescue

With this experience in mind, I looked for some tools. On Mac, you got Time Machine shipped with your OS, which is great. Many Linux distributions ship some tool for backup and restoring as well, and there is always rsync to do the job if nothing else is available. On Windows you have some basic functionality built in and a ton of tools to choose from. Running Linux, I decided to give [Obnam](http://obnam.org) a try. With the ability to do backups to hard drives and over sftp it fits my idea of putting backups on external drives as well as some remote server.

Obnam also has a nice concept of storing chunks of data which are automatically dedublicated, meaning every backup is a full backup but only new data needs to be transfered and takes away space. Every backup is a generation and you can decide which generations to keep and which are obsolete after a while. Obnam also makes it easy to encrypt your backup if you wish to do so. You'll need a pgp key and tell Obnam where to find it, but everything else is automated.

## Baby steps

Installing it on my Linux Mint was fairly easy. Mint uses Debian under the hood, so I could use apt (after adding the liw repository to my sources) to install the Obnam package which resolves all dependencies for me. That gave me the `obnam` command which is used to do backups and restores and work with generations of backups.

The most basic command to do a backup would be `obnam backup -r /path/to/repository /path/which/should/be/backed/up`. This creates a so called backup repository (which is a folder used by Obnam to store all data) at `/path/to/repository` and backup all data in `path/which/should/be/backed/up`. Also note that the repository can be in a remote location you have ssh access to by using sftp: `sftp://user@host:/path/to/repository`. If you want to backup different directories, you can specify as many as you want as the last parameters: `obnam backup -r /some/repo /home/user/dir1 /home/user/dir2 /home/user/dir3`.

Obnam takes arguments to not include cache directories into the backup (`--exclude-caches`) and to place a log at a location you choose where you can see what gets included in the backup (`--log /path/to/logfile.log`). There are more arguments for various tasks. If you want to exclude specific files or folders, you can do this as well. This works with regular expressions and I didn't really get it to work, so now I rather include the stuff I want then exclude the stuff I don't need. Works pretty well.

Also note that you can create a configuration file for Obnam to use. As I am doing my backups through a bash script, I don't care passing a few more parameters - If you intend on using Obnam manually, you might wanna look into setting some parameters in the configuration file so you don't need to repeat yourself.

## Lets script it!

With the tool at hand, I started writing a script which does a backup of my home directory to one of my external hard drives. After checking if the hard drive is connected, all there is left is the backup command for Obnam **and** the command to let Obnam forget previous backups if they are to old. You can tell Obnam which backups you want to keep and it will forget all the others. This is pretty neat as you don't need all those old ones around.

I decided to use the strategy often used when doing server backups: Keep one backup for the last 30 days each, one backup for each of the past 8 weeks and one for each of the last 14 month. This works well with the need to restore (you might remember you had a particular file last Wednesday but you won't remember if you had it 6 month or 7 monh ago) as well as with the amount of space your backups will consume. The command to let Obnam forget those older backups is: `obnam forget --keep="30d,8w,14m" --repository /path/to/repo`.

As I want to use different backup locations, I also added a parameter the script takes which decides which repository to use, which directories to backup and what to forget. You can have a look at the current version of the script in my dotfiles repository: https://github.com/Sgoettschkes/dotfiles/blob/master/bin/backup

## Afterthoughts

For the first time, I have a working backup solution in place. I have thought of different ways I could loose my data and my current backup solution makes sure I have a backup in any case. I can loose my laptop or even have a fire destroy my home office and be good backup-wise. At the same time, if my server looses my backups as well, I stil have an (older) backup on an external drive which is stored at a different location and will only be transfered to my laptop for backups every so often.

I didn't talk about restoring those data, but I'll do that in a second post. A backup you cannot restore is useless, so testing your backups is a good idea. And, like backups, this isn't done as often as it should because it's work nobody wants to do. With an (automatic) script you can take that work away and be sure of your backups working. I also skipped over encryption, because I don't use it currently. I might look into this in the future. If I decide to do so, I'll write an additional blog post.

As for Obnam itself, it's a great tool which does one thing and does it right. It has good documentation and it seems the developers have thought about the most common use cases and made them work flawlessly. Being a commandline tool it's also easy to create a script which does all the hard work and have you sit back, relax and enjoy all the other things in life - Not worried about your data anymore.
