---
layout: post
title: "Send and apply your patches over the network with netcat"
date: 2013-02-12 14:20
comments: true
categories: [Tips] 
---

For some of my works and mainly for testing them, I use virtual machines and containers (_that will be subject to another post_). 
Since I used to make the development outside the testing environnement, I need to quickly and easily transfer patches and test them.

If you are in a similar case, this tip is for you.

<!-- more -->

My case was an improvement of the php-memcached library. I assume that you have a git version of your project on both sides.

First, make your workspace clean on your testing environment. If your project has a configure file and if you don't need to refresh it on each iteration, do configure and commit all files.
We will return to this state at the beginning of each iteration with `git reset --hard`.

After that, we can use this oneliner:

```
while true ; do read ; git reset --hard ; nc -l -p 1234 | patch -p1 && make ; done
```
> The `read` command here prevents to reset the workspace just after the make. Press Enter is enough to launch a new iteration.

When your testing environment is listening and waiting for patch, you can launch this command on your development environment for each iteration: `git diff | nc -c ip 1234`.

> The option `-c` will close the connection on EOF from stdin

If you prefer to commit and amend your changes, just use `git format-patch -1` instead of `git diff`.

_Enjoy!_
