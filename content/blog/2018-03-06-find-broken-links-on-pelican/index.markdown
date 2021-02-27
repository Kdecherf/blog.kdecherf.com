Title: Find broken links on Pelican
Category: Blog
Tags: pelican
Date: 2018-03-06 23:09:00

Earlier this month I found, while reading some old blog posts, several dead
links. I decided to replace them with a link to the suitable capture on the
Internet Archive project.

Following that I thought it would be a good idea to check all links of the blog
looking for broken ones. And as automated as possible, indeed.

At first I came accross a plugin for Pelican,
   [pelican-deadlinks](https://github.com/silentlamb/pelican-deadlinks). This
plugin checks links and redirects broken ones to _archive.org_ at « compile »
time. Here's the major point with this behavior: links are replaced in the HTML
output of the blog, not in the source. I was quite unconfortable with this as I
wanted to propagate these changes to the source.

So I went back to search another tool and found
[riplink](https://github.com/mschwager/riplink). This little tool, written in
Go, takes an URL as argument and will fetch all links printing those with a
_4xx_ or _5xx_ response code. Eg:

``` bash
~ $ riplink -url https://google.com
~ $ riplink -url https://google.com -verbose
https://google.com 200
https://www.google.fr/intl/fr/options/ 200
https://www.google.fr/imghp?hl=fr&tab=wi 200
[…]
```
As I only want to check blog posts[^1], I use `riplink` jointly with `find` and a
`for` loop against the local server, which gives me:

``` bash
~ $ for i in $(find output/blog/ -mindepth 4 -maxdepth 4 -type d) ; do riplink -url http://localhost:8000/${i#output/*} ; sleep 1 ; done
http://www.microsoft.com/learning/en/us/book.aspx?ID=13487 404
http://www.microsoft.com/downloads/details.aspx?FamilyID=0FD9788A-5D64-4F57-949F-EF62DE7AB1AE 404
[…]
```

The last step is manual: for each broken link I search on the Internet
Archive the capture which is the closest to the time of the post.

_Enjoy!_

[^1]: the source of my blog consists of one folder by post, containing a
  `post.markdown` file
