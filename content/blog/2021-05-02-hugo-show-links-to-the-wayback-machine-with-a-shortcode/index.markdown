---
title: "Hugo: show links to the Wayback machine with a shortcode"
date: 2021-05-02T17:21:13+02:00
tags:
- hugo
---

I recently decided to migrate my blog from Pelican to a new static site
generator: [Hugo](https://gohugo.io), which is written in Go.

Hugo supports [shortcodes](https://gohugo.io/content-management/shortcodes/)
that let you render a template within your Markdown content file with a simple
snippet; and you can easily add your own shortcodes by dropping html files in
the folder `layouts/shortcodes`.

Here is an example with the built-in `ref` shortcode embed in a Markdown link:

``` markdown
[About]({{</* ref "/page/about" */>}})
```

The shortcode `ref` will print the absolute path to the internal page
`page/about` before Markdown is rendered. You can see it as the equivalent of
`[About]({filename}page/about)` on Pelican.

While migrating my content for Hugo, I though a shortcode would be a good way to
simplify the replacement of dead links to a snapshot on the Wayback machine.

Up until now, I replaced broken links with a full link including a hardcoded
timestamp for the Wayback snapshot:

``` markdown
[Microsoft Tag](http://web.archive.org/web/20100925234542/http://tag.microsoft.com/consumer/index.aspx){: .archive}
```

`{: .archive}` here was a way on Pelican to add a class attribute to the `a` tag
and I used it to append a Wayback icon next to the link.

I admit that the following snippet is far easier:

``` go
{{</* wayback "http://tag.microsoft.com/consumer/index.aspx" */>}}Microsoft Tag{{</* /wayback */>}}
```

So here is the template for the `wayback` shortcode saved in
`layouts/shortcodes/wayback.html`:

``` html
<a href="https://web.archive.org/web/{{ $.Page.Params.PublishDate.Format "20060102150405" }}/{{ .Get 0 }}" class="archive" title="You will be redirected to a snapshot on the Wayback Machine for {{ .Get 0 }}">
   {{ .Inner }}
   <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 59 66" fill="#fff" fill-rule="evenodd" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><use xlink:href="#A" x="1" y="1"/><symbol id="A" overflow="visible"><path d="M0 61.1h56.6V64H0zm2.23-5.6h52.226v4H2.23zM1.898 9.764h51.948v5.6H1.898zM2.23 8.09h51.26l1.56-1.73L27.89 0 .69 6.36zm7.16 24.92l-.224-8.2-.392-7.74c-.01-.2-.106-.27-.29-.312a10.82 10.82 0 0 0-4.588 0c-.184.04-.28.088-.29.312l-.392 7.74-.224 8.2.02 5.828.17 6.464.366 6.93.104 1.314a10.6 10.6 0 0 0 2.544.36c.844-.01 1.69-.14 2.544-.36l.104-1.314.366-6.93.17-6.464.02-5.828zm14.144 0l-.224-8.2-.392-7.74c-.01-.2-.106-.27-.29-.312a10.82 10.82 0 0 0-4.588 0c-.184.04-.28.088-.29.312l-.392 7.74-.224 8.2.02 5.828.17 6.464.366 6.93.104 1.314a10.68 10.68 0 0 0 2.544.36c.844-.01 1.69-.14 2.544-.36l.104-1.314.364-6.93.17-6.464.02-5.828zm16.404 0l-.224-8.2-.392-7.74c-.01-.2-.106-.27-.29-.312-.76-.166-1.526-.244-2.294-.246a10.82 10.82 0 0 0-2.294.246c-.184.04-.28.088-.29.312l-.392 7.74-.224 8.2.02 5.828.17 6.464.366 6.93.104 1.314a10.68 10.68 0 0 0 2.544.36c.844-.01 1.69-.14 2.544-.36l.104-1.314.366-6.93.17-6.464.02-5.828zm13.812 0l-.224-8.2-.392-7.74c-.01-.2-.106-.27-.29-.312-.76-.166-1.526-.244-2.294-.246a10.82 10.82 0 0 0-2.294.246c-.184.04-.28.088-.29.312l-.392 7.74-.224 8.2.02 5.828.17 6.464.364 6.93.104 1.314a10.68 10.68 0 0 0 2.544.36 10.6 10.6 0 0 0 2.544-.36l.104-1.314.366-6.93.17-6.464.02-5.828z" stroke="none" fill="currentColor" fill-rule="nonzero"/></symbol></svg>
</a>
```

`{{ $.Page.Params.PublishDate.Format "20060102150405" }}` will print out
the published date of the calling post in a format understood by the Wayback
machine. This way we don't even need to hardcode a snapshot timestamp, the
Wayback machine will give you the snapshot as close as possible to the
published date of your blog post.

Here are the CSS definitions I use for the class `archive`:

``` css 
.post-content a.archive {
  color: inherit;
  border-color: inherit;
}
.post-content a.archive svg {
  vertical-align: super;
  height: 12px;
}
```

Then the snippet `{{</* wayback "kdecherf.com" */>}}Homepage{{</* /wayback */>}}` would
be rendered as follow: {{< wayback "kdecherf.com" >}}Homepage{{< /wayback >}}.

_Enjoy_
