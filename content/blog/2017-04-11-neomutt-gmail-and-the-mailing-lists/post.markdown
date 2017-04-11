Title: NeoMutt, Gmail and the mailing lists
Category: Blog
Tags: mutt, neomutt, gmail
Date: 2017-04-11 22:32

For a long time Gmail filters were keeping my inbox clean by automatically
archiving all emails incoming from mailing lists. Even if it looks efficient,
there's actually a big issue.  Do you seriously take time to read all these
unread archived emails?

If you already missed an important vulnerability report or answered to a
two-year old unanswered question on a mailing list, take a seat.

Back in the days when I started to use Mutt, I also started to auto-archive
mailing lists for two reasons:

* Some mailing lists keeps the original subject which provides no way to
  easily read the name in the index view of Mutt
* And I lost the color of my Gmail labels

Few weeks ago I started looking for a way to remove this auto-archive and still
keep a _readable_ inbox.

The first thing was to always have the mailing list name on the index view.
I discovered `%L` while reading some Mutt documentation. Used in
`$index_format`, `%L` will print the list-name if an address defined in
`subscribe` if found in the `To` or `CC` headers.

So, basically I listed all mailing lists to which I am subscribed like this in
my `.muttrc`:

``` mutt
subscribe ceph-users@lists.ceph.com ceph-users@ceph.com ceph-devel@vger.kernel.org
subscribe haproxy@formilux.org
subscribe riak-users@lists.basho.com
subscribe systemd-devel@lists.freedesktop.org
# And so on…
```

The downside of this feature is that it will print the maildir folder if no
subscribed address is found:

> **%L**  
>   If an address in the To or CC header field matches an address defined by the
>   users ``subscribe'' command, this displays "To &lt;list-name&gt;", otherwise the
>   same as %F.

It's important to say here that I recently replaced Mutt with NeoMutt, a quite
active fork which includes a lot of patches like the sidebar and notmuch
support.

So… Let's do some hacking.

After few hours in some C files, I proposed a change to NeoMutt: [add support of
%K](https://github.com/neomutt/neomutt/pull/452). `%K` is basically like `%L`
but it will remain empty if no subscribed address is found and it can be used
with a condition (`%?x?&?`).

With this change we can have an `$index_format` of the following form:

``` muttrc
set index_format = "%4C (%4c) %Z %?GI?%GI& ? %[%d/%b]  %-20.19F %?K?%15.14K&               ? %?M?(%3M)&     ? %?X?¤& ? %s %> %?g?%g?"
```

Which will create a dedicated column for the list name like in the following
image:

![NeoMutt, K support]({attach}neomutt-k.png)

In the previous example `%?K?%15.14K&               ?` instructs Mutt to:

 * `%?K?%15.14K`: print the first 14 characters of `%K` in a field limited to 15 characters if `%K` is not empty
 * `&               ?`: print 15 whitespaces otherwise

Now that I have a textual equivalent to Gmail labels, there is one thing left: colors.

Let's do some really nasty things with `color index` and patterns:

``` muttrc
color index color73 default "~C haproxy@formilux.org"
```

This line will use color73 as foreground color for all emails sent to the
HAProxy mailing list.

We can even have a bold color for new emails from this mailing list:

``` muttrc
color index brightcolor73 default "~N ~C haproxy@formilux.org"
```

Here is an excerpt of my subscriptions configuration file for Mutt:

``` muttrc
subscribe ceph-users@lists.ceph.com ceph-users@ceph.com ceph-devel@vger.kernel.org
color index color73 default "~C ceph-users@lists.ceph.com | ~C ceph-users@ceph.com | ~C ceph-devel@vger.kernel.org"
color index brightcolor73 default "~N (~C ceph-users@lists.ceph.com | ~C ceph-users@ceph.com | ~C ceph-devel@vger.kernel.org)"

subscribe haproxy@formilux.org
color index color42 default "~C haproxy@formilux.org"
color index brightcolor42 default "~N ~C haproxy@formilux.org"

subscribe riak-users@lists.basho.com
color index color30 default "~C riak-users@lists.basho.com"
color index brightcolor30 default "~N ~C riak-users@lists.basho.com"

subscribe frnog@frnog.org frnog-.*@frnog.org
color index color3 default "~C frnog@frnog.org | ~C frnog-.*@frnog.org"
color index brightcolor3 default "~N (~C frnog@frnog.org | ~C frnog-.*@frnog.org)"

subscribe frsag@frsag.org
color index color10 default "~C frsag@frsag.org"
color index brightcolor10 default "~N ~C frsag@frsag.org"
```

Yes, I'm using a dedicated color for each mailing list. The complete file gives me the following colored inbox:

![NeoMutt]({attach}neomutt.png)

_Note: the support of `%K` should land in the next release of NeoMutt. If you
want it now you should patch your installation using
[this patch](https://github.com/neomutt/neomutt/commit/6be374b7e8d2b1d794b05836493ddf62dd9b427e.patch)._

For more information:

* [`$index_format` in Mutt's documentation](http://www.mutt.org/doc/manual/#index-format)
* [`$index_format` in NeoMutt's documentation](https://www.neomutt.org/guide/reference#index-format)
* [Mailing Lists in Mutt's documentation](http://www.mutt.org/doc/manual/#lists)
* [Patterns in Mutt's documentation](http://www.mutt.org/doc/manual/#patterns)

_Enjoy!_
