---
title: "Wallabag: add colors to tags with pure CSS"
date: 2021-05-15T23:49:40+02:00
tags:
- wallabag
---

Tags and tagging rules are a good way to easily organize your content on
wallabag, whether it's for showing topics of an entry or marking entries you
want to read next. As an illustration I rely on more than 180 tags on my own
instance, ranging from topics, tech-related topics, reading time "buckets",
papers, periodicals to whether an entry has been exported on my ebook reader.

How to promptly catch some specific tags like `error` or `export` without
actually reading their label when they all share the same color? Let's take a
look at my dev instance:

![Tags without colors](image1.png)

For now there's no native feature in wallabag to assign a color to a tag.
However tags are just html tags in pages; and they can be easily targeted by CSS
rules using some unique attributes: wallabag tags are basically `<li>` tags with
a `title` attribute[^1] containing their label.

In this way, let's take this simple rule:

``` css
li[title="error"] {
  background-color: #cc0000;
}
```
It will override the color of tags having the label `error` to red.

This rule works well for fixed labels, but it can be a PITA if you have a lot of
tags like `error:img`, `error:config` or `error:fetch`. If you want to set the
color of all these tags to red you may want a broader CSS rule using a "prefix
selector". The rule seen above could be changed to:

``` css
li[title^="error"] {
  background-color: #cc0000;
}
```
Then, all tags having a label prefixed with `error` will have a red
background.

Now, we need to restrict the rule to the specific contexts where tags are
shown[^2]:

``` css
:is(#article aside, .card-stacked div.metadata, .card-entry-labels, .card-tag-labels) li[title^="error"] {
  background-color: #cc0000;
}
```

We have our rule but how do we actually put it in the application?

Adding custom CSS rules to the supplied asset files is not a sustainable way to
add colors as the files are minified and will be replaced each time you update
the application; luckily a new feature landed in wallabag v2.4.0 lets you add
custom css rules outside of the app files.

Put your rules in `web/custom.css` and the magic will happen.

Here are the rules I use for my instance:

``` css
:is(#article aside, .card-stacked div.metadata, .card-entry-labels, .card-tag-labels) li[title^="error"] {
  background-color: #d32f2f;
}

:is(#article aside, .card-stacked div.metadata, .card-entry-labels, .card-tag-labels) li[title^="export"] {
  background-color: #5d4037;
}

:is(#article aside, .card-stacked div.metadata, .card-entry-labels, .card-tag-labels) li[title^="tech"] {
  background-color: #455a64;
}

:is(#article aside, .card-stacked div.metadata, .card-entry-labels, .card-tag-labels) li[title^="topic"] {
  background-color: #33691e;
}

:is(#article aside, .card-stacked div.metadata, .card-entry-labels, .card-tag-labels) li[title^="todo"] {
  background-color: #4a148c;
}

:is(#article aside, .card-stacked div.metadata, .card-entry-labels, .card-tag-labels) li[title^="@"] {
  background-color: #5d4037;
}

:is(#article aside, .card-stacked div.metadata, .card-entry-labels, .card-tag-labels) li[title^="periodical"] {
  background-color: #3f51b5;
}
```

These rules give the following result on my dev instance:

![Tags with colors](image2.png)

It's now easier to see at a glance entries with errors or entries which were
already exported.

## Further reading

* [CSS Attribute selectors on the MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors)

_Enjoy!_

[^1]: A fix in v2.4.1 unified the `title` attribute everywhere tags are showed
[^2]: As for wallabag v2.4.2 with the default Material theme
