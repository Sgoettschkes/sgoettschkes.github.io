---
layout: post
category: dev
tags: [ansible, devops, vagrant, dart]
title: "Idempotent version updates with Ansible"
author: Sebastian
date: 2016-02-29 10:00:00
---
If you are a seasoned Vagrant user, you know the problem around provisioning. If some software version changes, everybody needs to provision his or her machine again. Otherwise, things will fail eventually. You'll also run into problems if running the provisioning twice fails for some reason (e.g. because a file already exists somewhere).

## Idempotent setup

If you are setting up your provisioning, the first thing you need to make sure is that you can run the setup steps more than once and it works without manual steps in between. Nothing is more frustrating than running `vagrant provision` and being left with errors because something is already installed or a file is already at a specific place.

This is easy to do, even with a basic shell provisioner. You can check for the existence of files and test if some software is already installed. It's also pretty easy to test: Just run the provisioning again and see if it works. If not, add appropriate tests and not run the offending commands.

## Updating vs. optimizing

Getting the provisioning step to update software to the correct version is more tricky. It's easy with package managers like composer for PHP or pip for Python where you have a file containing all dependencies and their versions and the package manager takes care of the rest. If you need to download, compile and install a library, you are faced with three very different options: You can do all the steps every time when provisioning, which takes time even though most of the time nothing changed. You can also install it once and then forget about it, which means nothing happens if a new version for a software is available. The third thing is figuring out the current version as well as the target version and only run the steps for installing it if they don't match.

With Ansible, the Vagrant provisioner of choice for me, all three ways are possible. It's important to be clear which one you are choosing so you know what drawbacks your solution might have.

To run some steps every time, give them no restriction like `creates` for commands and Ansible will do as told. If you are using the `command` or `shell` module, Ansible will run it every time. If your process is downloading some tar or zip and extracting it, maybe running a setup command as well, Ansible will download it every time and you'll get new versions available under the url.

If you wanna run the whole process only once , use `creates` or similar instructions. Ansible will check if the file or directory is there and if it is, skip the step. As an example, let's say you download some tar and extract it somewhere. The `unarchive` module takes a parameter called `creates`. If you set it to the extracted path, the command will do nothing if that folder is already there. As Ansible can't possible figure out if the version inside the tar is the same as the existing one, it won't unarchive it even though the version changed.

## Conditionals

If you want to run a command or a set of commands only if the installed version of a software differs from the target version, things are getting interesting. Let me walk you through that scenario. As an example, I'll use the Dart SDK.

First, we need a command to get the current version installed. For Dart, that's reading the `version` file which contains only the version string. Other tools might make this more complicated, e.g. the Google Cloud SDK, which prints a lot of information in addition to the version when running `gcloud --version`. I usually use some command line magic like `sed` or `cut` to extract the part I need. Using the `shell` module from ansible, I pipe them together to end up with the version being the stdout for that command. We need to use `register` to put the output of that task into a variable. The whole task could look like this:

    - name: Read the dart version
      shell: cat /usr/local/lib/dart-sdk/version
      register: current_dart_version
      ignore_errors: True
      changed_when: dart_version != current_dart_version.stdout

As you can see, I ignore errors because the shell command might fail if dart is not installed. I use `changed_when` because I like a clean output from Ansible. You can also see a variable named `dart_version` which I did not mention yet. It's simply a variable keeping the target dart version.

Next, let us download the Dart SDK if needed:

    - name: download dart sdk
      get_url:
        dest=/tmp/dartsdk.zip
        force=yes
        url=https://storage.googleapis.com/dart-archive/channels/stable/release/{{ dart_version }}/sdk/dartsdk-linux-x64-release.zip
      when: dart_version != current_dart_version.stdout

Again, we use the `dart_version` as a target both in the url and for the `when` clause which compares the stdout from the above command with our target. The last step is to extract the zip:

    - name: extract dart sdk
      unarchive:
        copy=no
        dest=/usr/local/lib
        src=/tmp/dartsdk.zip
      when: dart_version != current_dart_version.stdout

The same pattern repeats here as well. We only run the command if the target version is different from the current one. You can use this pattern for all kinds of installation and steps performed after the installation is done.

## Getting fail-safe

Even though this seems very much all you can want from a provisioning step, if you have to take care of real servers in production, you might want to be even more cautious. In the example above, if some files are not present in the new SDK, they are not deleted as the extract commands does not take care of this. We could work around this by first deleting the SDK.

In production, it might be valuable to not just replace a version but have two versions installed and switch a symlink or something to change over. This way, it's not possible that a process has access to the software in an unpredictable state.

One tip regarding the version extraction: There are different ways to read the version! You might be able to read the version from some version-file or run the command with a `COMMAND --version` parameter. Look for different ways and see if some outputs only the exact version. And if you have to, using some regex with `sed` might not be the cleanest way but it does the job.
