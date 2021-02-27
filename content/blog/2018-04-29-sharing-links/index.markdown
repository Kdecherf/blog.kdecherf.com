---
title: "Sharing links"
date: 2018-04-29T21:52:42+02:00
tags:
- Thoughts
---

Here is a little post to show what is my workflow for sharing links, hoping it
could inspire you.

For many years I used to share links solely on Twitter and sometimes with some
URL shorteners. This workflow relies on the durability of several third-party
tools: Twitter, the URL shortener and the shared link itself.

It gets complicated when the shared link or the URL shortener disapears,
breaking some tweets and, maybe, frustrating some people.

The last year, in a phase when I was rethinking of my use of online tools (_which
      will be the subject of a later post_), I decided to change my way of
keeping track and sharing links. I installed
[Shaarli](https://github.com/shaarli/Shaarli), a tool written in PHP which uses a
flat database and started to save links into it.

As I also wanted to keep track of the source of the saved link I added a known
plugin to my installation:
[shaarli-plugin-via](https://github.com/kalvn/shaarli-plugin-via) which lets you
add an additional link to a saved link as the original source.

As I save a number of links originated from tweets, I wanted to add an icon to
show when the original link was actually a tweet. I forked the plugin, adding
the support of a twitter icon, which is available here:
[Kdecherf/shaarli-plugin-via](https://github.com/Kdecherf/shaarli-plugin-via).

![Shaarli Via](shaarli-via.png)

Having this tool lets me archive links and quickly search on it without the fear
of seeing the service disapear (_Hello, Delicious?_).

Though I must admit that almost nobody will visit my personal database of links
I still need to keep posting them on Twitter (_'cause it's important to share
      the knowledge_). I thought it would be great to narrow the required steps
for sharing content by integrating it directly into Shaarli. Thus I published
another plugin:
[Kdecherf/shaarli-plugin-buffer](https://github.com/Kdecherf/shaarli-plugin-buffer).
This one relies on Buffer[^1], a third-party tool for posting content on several
social networks.

The plugin will basically handle the post of saved links to Twitter using
several sharing policies like: _post using schedule_, _post using schedule but
on top of the current queue_, _post now_, and so on. Furthermore the plugin
interacts with the plugin `via` to check if the saved links comes originally
from a tweet, then it will post this tweet as a retweet instead of making a
tweet on its own.

There's another tiny but still useful plugin on Shaarli: archiveorg, which adds a
link to archive.org in case the saved link disapears.

### Retweets versus new tweets

As I value the original poster more than some analytics, I consider that
retweeting original tweets is more meaningful than posting new tweets. And it
does not matter if the original tweet disappears as I have a copy of the link on
my side now.

If you are interested to see what am I sharing,  you can come here:
[https://links.kdecherf.com](https://links.kdecherf.com)

_Enjoy!_

_Since the installation of Shaarli I saved and shared more than 900 links, and counting._

[^1]: We could discuss about the choice but I'm still happy with it.
