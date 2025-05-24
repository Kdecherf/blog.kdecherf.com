---
title: "Fetch content from browser on-demand with wallabagger"
date: 2023-08-02T22:48:16+02:00
tags:
- wallabag
---

Une traduction française est disponible [ici]({{< ref "/blog/2023-08-02-récupérer-un-article-depuis-le-navigateur-avec-wallabagger/index.markdown" >}}).

[Wallabagger][1] is a browser extension that let's you save pages on your
wallabag account.

Starting from [v1.14.0][2] the extension is able to take the content of the
page from the browser and send it to wallabag, so that the server does not have
to fetch the page by itself. This allows you to save pages that may fail
otherwise (_e.g. pages with heavy javascript or behind a paywall_).

Up until recently I've used a custom integration of mine to perform the same
thing using WebScrapBook[^2]. But as the related browser extension had an
update with important breaking changes, I though it was too much work to fix it
and I gave a new try to wallabagger.

While I was satisfied by the results, putting specific domains in a list was
pretty inflexible.

The release of [v1.16.0][3] added an option to fetch content from the browser
by default, giving the ability to ignore the domain list. This is pretty cool.
However I found it nearly as inflexible as the previous version, as I still
want to save some pages the old way.

How could I have the ability to easily chose between either fetching content
from the browser or not when saving a page through this extension? A few weeks
ago I started to dig into the source code. And while going through the
different files, something caught my attention in the extension manifest.

There are two shortcuts set and available for several actions:

![Firefox extension shortcuts view of wallabagger](firefox-shortcuts.png)

Understanding the difference between these two actions actually gave me a
workaroung for what I want.

Considering that the "_Retrieve content from the browser by default_" option is
enabled:

* "_Activate toolbar button_" will save a page by using content from the browser
* "_Save the page into Wallabag without opening the popup_" will save a
  page through the background worker and thus ignore the option, letting the
  server fetching the content

In short, when you're on a page you want to save on wallabag, use `Alt+W` to
fetch content from browser, otherwise use `Alt+Shift+W`.

Follow [these instructions][4] to change these shortcuts on Firefox. I guess
there's a similar way to change them on Chrome-based browsers.

_Enjoy_

[1]: https://wallabag.github.io/wallabagger/
[2]: https://github.com/wallabag/wallabagger/releases/tag/v1.14.0
[3]: https://github.com/wallabag/wallabagger/releases/tag/v1.16.0
[4]: https://support.mozilla.org/en-US/kb/manage-extension-shortcuts-firefox
[^2]: [wallabag vs the web in 2022: the poor's man solution]({{< ref "/blog/2022-03-21-wallabag-vs-the-web-in-2022-the-poors-man-solution/index.markdown" >}})
