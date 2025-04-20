---
title: "Wallabag: fetch articles from tweets"
date: 2021-06-25T16:56:25+02:00
tags:
- wallabag
- twitter
---

{{< alertbox "info" "UPDATE 2021/12/04" >}}
  Updated XPath query to reflect recent changes on what is returned by Twitter.
{{< /alertbox >}}

{{< alertbox "info" "UPDATE 2021/11/11" >}}
  Updated XPath query to handle threaded tweets.
{{< /alertbox >}}

Twitter is one of my primary sources of content to read, the other being RSS
feeds.

But unlike the RSS feeds, when I submit a twitter link to a wallabag instance it
will only fetch the tweet. Then I will need to do an extra action to fetch the
article that was originally in this tweet.

We'll take the following tweet for the illustration:

{{< tweet user="Kdecherf" id="1394723094183428101" >}}

It would be perfect if wallabag was able to directly fetch the linked article.

Well… The good news is it's quite simple to achieve that.

Behind the scene wallabag uses site-config files to apply advanced instructions
to extract content.

As an example, here are some instructions for twitter.com:

```
title: //title
body: (//p[contains(@class, 'js-tweet-text')])[1]
author: (//strong[contains(@class, 'fullname')])[1]
http_header(User-Agent): Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)
```

These instructions basically say to find title, body and author according to
these specific XPath queries. The last line says to set  the specified value for
the header User-Agent before sending the request.

Among all supported instructions there is one that lets you instruct the
fetching tool to eventually fetch a link that can be found in the fetched
content. This instruction is `single_page_link` and was originally added for
articles that spawn over several pages but provide a link for fetching the whole
content at once.

Here was the DOM tree of a tweet page returned by Twitter before a recent
change[^1]:

``` html
<!-- [clipped] -->
<div class="tweet permalink-tweet js-actionable-user js-actionable-tweet js-original-tweet has-cards no-replies js-initial-focus focus" data-associated-tweet-id="1394723094183428101" data-tweet-id="1394723094183428101" data-item-id="1394723094183428101" data-permalink-path="/Kdecherf/status/1394723094183428101" data-conversation-id="1394723094183428101" data-tweet-nonce="1394723094183428101-041d44f2-9198-4194-86c2-cabb9c6526d4" data-tweet-stat-initialized="true" data-screen-name="Kdecherf" data-name="Kevin Decherf" data-user-id="21924424" data-you-follow="false" data-follows-you="false" data-you-block="false" data-reply-to-users-json="[{&quot;id_str&quot;:&quot;21924424&quot;,&quot;screen_name&quot;:&quot;Kdecherf&quot;,&quot;name&quot;:&quot;Kevin Decherf&quot;,&quot;emojified_name&quot;:{&quot;text&quot;:&quot;Kevin Decherf&quot;,&quot;emojified_text_as_html&quot;:&quot;Kevin Decherf&quot;}}]" data-disclosure-type="" data-card2-type="summary" data-has-cards="true" tabindex="0">
   <div class="content clearfix">
   <!-- [clipped] -->
   </div>

   <div class="js-tweet-text-container">
      <p class="TweetTextSize TweetTextSize--jumbo js-tweet-text tweet-text" data-aria-label-part="0" lang="en">
         New post: 'Reclaim disk from Ignite and Firecracker'
         <a href="https://t.co/oR2XfX7LV3" rel="nofollow noopener" dir="ltr" data-expanded-url="https://kdecherf.com/blog/2021/05/18/reclaim-disk-from-ignite-and-firecracker/" target="_blank" title="https://kdecherf.com/blog/2021/05/18/reclaim-disk-from-ignite-and-firecracker/" class="twitter-timeline-link"><span class="tco-ellipsis"></span><span class="invisible">https://</span><span class="js-display-url">kdecherf.com/blog/2021/05/1</span><span class="invisible">8/reclaim-disk-from-ignite-and-firecracker/</span><span class="tco-ellipsis"><span class="invisible">&nbsp;</span>…</span></a>
      </p>
   </div>
   <!-- [clipped] -->
</div>
```

~~We can see that even if Twitter overrides the `href` property with their url
shortener, the actual link is available in the `data-expanded-url` property.~~[^2]

Then we could use the following XPath query to extract the link we want:

```
//meta[@itemprop='mainEntityOfPage']/parent::div//article//a[contains(@rel, 'noreferrer') and contains(@href, 'https://t.co')]/@href
```

Now that we have the XPath query we can use it with a `single_page_link`
instruction to order wallabag to follow any link it would find in a tweet page.
For that we need to add the following line to the file
`vendor/j0k3r/graby-site-config/twitter.com.txt`:

```
single_page_link: //meta[@itemprop='mainEntityOfPage']/parent::div//article//a[contains(@rel, 'noreferrer') and contains(@href, 'https://t.co')]/@href
```

With this modification, sending the link
`https://twitter.com/Kdecherf/status/1394723094183428101` to wallabag will now
fetch
`https://kdecherf.com/blog/2021/05/18/reclaim-disk-from-ignite-and-firecracker/`;
which is the link that can be found in the tweet.

### Why not pushing this change to upstream?

I could have proposed this change to the repository used by wallabag and other
applications. However this new behavior may not be what users want as the
default, like for Reddit.

### Further reading

* GitHub repository for site-config files used by wallabag: https://github.com/fivefilters/ftr-site-config
* List of instructions supported by site-config files: https://help.fivefilters.org/full-text-rss/site-patterns.html
* XPath documentation on the MDN: https://developer.mozilla.org/en-US/docs/Web/XPath

[^1]: Without specifying the User-Agent of Googlebot, Twitter sends a
  client-side rendered page with javascript, see https://github.com/fivefilters/ftr-site-config/pull/837
[^2]: Twitter recently changed the way they show tweets, the attribute
  `data-expanded-url` is no longer available and the DOM tree is clogged with a
  lot of crap.
