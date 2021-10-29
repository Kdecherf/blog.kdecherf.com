---
title: "Wallabag: get a sepia mode for reading"
date: 2021-10-29T17:35:03+02:00
tags:
- wallabag
---

I already talked about the way to customize CSS on wallabag v2.4+ instances in a previous post [about tags]({{< relref "/blog/2021-05-15-wallabag-add-colors-to-tags-with-pure-css" >}}).

Today I'll show you how to use this feature to have a "sepia mode" for reading articles on your instance.

This color scheme lets you read content with a warmer tone than a classic light theme (_like the default white background_). It can be referred sometimes as a 'reading mode' (_e.g. on Android devices_).

So with the help of schemes we can find online, here is the result of a sepia color scheme for wallabag:

![preview](preview.jpg)

In order to have this, add the following content to `web/custom.css`:

``` css
#article {
  box-shadow: none;
  background: inherit;
}

.entry #main {
  background: #fbf0d9;
}

#article,
#article article {
  color: #191919;
}

#article pre,
#article img {
  filter: sepia(50%);
}

#article article a {
  filter: sepia(25%);
}
```

Two notes about this style:
- It removes the default box-shadow you have on entries
- It applies a browser-based sepia filter on images, code snippets and links

### Further reading

- [sepia() filter on MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/filter-function/sepia())

_Enjoy_
