---
layout: post
category: tools
tags: [tools, backup, obnam, data recovery, data integrity, data restoring]
title: "Testing backup integrity with obnam"
author: Sebastian
date: 2014-06-28 19:48:00 UTC
---
After I told you how to do [backups with obnam](http://sgoettschkes.me/p/backups-with-obnam.html), we should see how we can restore that data in case of an emergency and also how to test if the backups are working as expected. To do this, we have several steps: Look into how the restore procedure for obnam looks like, thing of how we can verify if backups are working and then implementing those steps in order to automate them.

## People are lazy: A lesson learned

We are all lazy people. And we are busy. We set up a backup method and then forget about it. It worked once, why should it stop working? And then it's time to shine for your backup because you deleted that one important file or your harddrive stopped working. And that's when one discovers that the path to the files which should be backed up changed and the last backup is 6 month old.

At my old company, we detected that the last database backup was indeed 6 month old because somebody changed the password for all users and the backup script couldn't run anymore. It was pure luck we discovered this without a concrete incident.

To prevent this, what I did for one of my side projects I wrote a bash script which would download the datbase backups, import them into a local database instance and then run some queries. It worked pretty well and I was always sure that backup worked.

## Restore with obnam

