---
title: "Wallabag vs the web in 2022: the poor's man solution"
date: 2022-03-14T22:47:16+01:00
tags:
- wallabag
draft: true
---

This post is the first of a series about wallabag and the dirty things I do
with it.

It has been mostly 6 years since I started to use wallabag as my main tool to
read content on the web; and I quickly started contributing to it on my sparse
time. Wallabag does not only save pages I want to read, it also saves me time
by avoiding all these pesky pop-ups, ads and other cookiewalls.

In order to do that, wallabag retrieves the content of an article by making a
basic HTTP call and parsing the HTML file it receives in response. This works
in most cases but it can be defeated by bot protection or if the page loads its
content using javascript, e.g. on Bloomberg or websites behind Cloudflare.

For a while I accepted this fate but lately I decided to find a workaround in
order to continue reading 'cleaned' articles.

The easiest way to achieve that is to save the content directly from the browser
as you surf through it. Okay, we know the destination but how do we go there?

[Wallabagger][:wallabagger] is a browser extension that lets you save pages to
your wallabag's account. As of now it only takes the url of the active page and
sends it to wallabag, letting the server fetching the content.

The logical path would be to update the extension to add the ability to capture
and send the actual content in addition to the url.

Spoiler alert: I decided to go over another way; my willingness to do
JavaScript was pretty low 🙃. While searching for browser extensions capable of
saving pages, I came accross several interesting ones:

* [WebScrapBook][:webscrapbook]
* [SingleFile][:singlefile]

They both save the content of the page locally and do it well; but WebScrapBook
has a feature that attracted my attention: the support of a backend to store
the saved content remotely. I found a [working backend implementation in Python][:pywebscrapbook].

A few hours later I had a very limited but working WebScrapBook backend API
support in wallabag. It basically relies on the import mechanism and
on [a recent change][:graby] that landed in Graby.

Here is the raw patch:

""code""

""note on token""

Now that wallabag can act as a WebScrapBook remote backend, we configure the
browser extension accordingly:

![screenshot](screenshot.png)

The address is your wallabag's address with `/import/wsb/` appended. Use your
account's email address as the user and the token you set earlier as the
password. You can also change some settings if you want to handle images, fonts
and other things in a specific way.

Now, when you hit "Capture tabs", WebScrapBook grabs the loaded content and
saves it to wallabag.

This solution is not bulletproof however; up until now I encountered two
drawbacks:

1. Some websites alter the page content using JavaScript after initial loading,
   baring the browser extension from grabbing the page fully. "Capture tabs
   (source)" can fix this but not always
2. Objects like iframes and SVG are still missing in the saved entry (_and it
   really annoys me_)

Anyway, here we are, with a dirty but working solution to capture pages that
can't be normally saved by wallabag.

I guess you're telling yourself that adding the missing feature to wallabagger
would probably be more relevant. I will be honest: I won't take time to do it.
But if you want to contribute, feel free to open a PR on its repository.

Regarding the WebScrapBook backend support in wallabag, I'm considering it for
inclusion in upstream. Feel free to give your feedback on GitHub, Twitter or
Reddit about it.

Last but not least, I would be pleased to hear you if you have ideas or already
worked on a generic way to capture embedded contents like SVGs (_e.g. charts on
medias like The Guardian_) in a way that would fit wallabag.

In the next post I'll explore the feasability of using a headless browser on
the server side.

_Enjoy!_

[:wallabagger]: https://github.com/wallabag/wallabagger
[:webscrapbook]: https://github.com/danny0838/webscrapbook
[:singlefile]: https://github.com/gildas-lormeau/SingleFile
[:pywebscrapbook]: https://github.com/danny0838/PyWebScrapBook
[:graby]: https://github.com/j0k3r/graby/pull/274
