---
title: "Reconstruct thread with NeoMutt and Notmuch"
date: 2018-02-25T21:54:14+01:00
tags:
- neomutt
- mutt
- notmuch
---

A few years ago I installed Notmuch on my computer in order to keep an index of my
mailbox. Though Notmuch is quite awesome, I didn't fully configure it until
recently. As I eventually moved from Mutt to NeoMutt for its native Notmuch
backend integration (_and a bunch of other cool features too_) I began to rely
more on it.

As messages are indexed by Notmuch in term of messages and threads, one of many
possible uses of this tool is its ability to retrieve an entire thread matching
a criteria or including a given message.

One can integrate this use in Mutt using a wrapper named `notmuch-mutt`
and declaring a macro [similar to this](https://upsilon.cc/~zack/blog/posts/2011/01/how_to_use_Notmuch_with_Mutt/mutt-notmuch.1.html):

``` muttrc
macro index <F9> \
          "<enter-command>unset wait_key<enter><pipe-message>~/bin/mutt-notmuch thread<enter><change-folder-readonly>~/.cache/mutt_results<enter><enter-command>set wait_key<enter>" \
          "search and reconstruct owning thread (using notmuch)"
```

You can also find a more complete macro on the [ArchLinux wiki page for Notmuch](https://wiki.archlinux.org/index.php/Notmuch#Integrating_with_mutt).

This approach does not convince me, as it works basically by emitting a Notmuch
query from a Perl wrapper, saving the result in a temporary file and showing it
back in Mutt.

As NeoMutt has a native support of Notmuch backend, we should be able to do the
same thing without external wrapper. I noticed one function while reading the
list of available functions: `entire-thread`. I quickly checked in the source
code and it does what I want: it queries Notmuch to find the whole thread
including the selected message and shows it back in NeoMutt.

However there's a little difference between these two implementations: the
result is virtually injected in the current view instead of being put in a new
dedicated vfolder. It can be confusing, but at least it does what I want and
takes no time to do it. And you just need to reload the open folder when you
want to get rid of the reconstructed threads.

Example of my INBOX folder before retrieving the entire thread of a GitHub
notification:

![Before](notmuch-neomutt-before.png)

And after, still my unchanged INBOX folder:

![After](notmuch-neomutt-after.png)

I bound this function to the `x` key like this:

``` muttrc
bind index,pager x entire-thread
```

_Enjoy!_
