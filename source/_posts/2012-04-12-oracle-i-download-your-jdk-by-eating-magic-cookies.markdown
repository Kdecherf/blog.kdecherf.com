---
layout: post
title: "Oracle, I download your JDK by eating magic cookies"
date: 2012-04-12 21:15
comments: true
categories: [Tips]
---

<div class="alert-info">
<strong>UPDATE 2013/05/26:</strong> As noted by <em>frog end</em> and <em>Kip</em> in comments, wget 1.12 (<em>mainly on CentOS systems</em>) is unable to handle SAN SSL certificates (<em>Subject Alternative Name</em>) and will fail on <code>edelivery.oracle.com</code>. Use <code>--no-check-certificate</code> to avoid this issue.
</div>

Today, I had to install the <span style="text-decoration:line-through;">Sun</span>Oracle JDK on some servers, so I visited the [JDK download page](http://www.oracle.com/technetwork/java/javase/downloads/jdk-7u3-download-1501626.html) to retrieve the direct download link for `wget` on each server:
```
$ wget http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm
```

After launching the command, the server redirects me to a 5K HTML file:
```
Location: http://download.oracle.com/errors/download-fail-1505220.html [following]
```

WAIT, WHAT? I can't download the file if I don't visit their download page to accept the OTN license.


Challenge accepted, I'm going to play with requests... What happens when I click on the archive link?

First request:
```
Request URL:http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm
Request Method:GET
Cookie:s_nr=some_integer; s_cc=true; gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk-7u3-download-1501626.html; s_sq=%5B%5BB%5D%5D
```

Okay, trying to play with cookie values (_I deleted the useless values_):
```
$ wget --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk-7u3-download-1501626.html;" http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm

--2012-04-12 18:47:58--  http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm
Resolving download.oracle.com (download.oracle.com)... 24.29.138.48, 24.29.138.40
Connecting to download.oracle.com (download.oracle.com)|24.29.138.48|:80... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://edelivery.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm [following]
--2012-04-12 18:47:59--  https://edelivery.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm
Resolving edelivery.oracle.com (edelivery.oracle.com)... 2.18.222.174
Connecting to edelivery.oracle.com (edelivery.oracle.com)|2.18.222.174|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm?AuthParam=THEIR_AUTHPARAM [following]
--2012-04-12 18:48:00--  http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm?AuthParam=THEIR_AUTHPARAM
Connecting to download.oracle.com (download.oracle.com)|24.29.138.48|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 67667318 (65M) [application/x-redhat-package-manager]
Saving to: `jdk-7u3-linux-x64.rpm'
```

Fuck Yea.

### More information
You can set what you want in `gpw_e24`, I think it's a kind of referer. As for me, I'm using the download page URL.

According to the [OTN BCL document for Java SE](http://www.oracle.com/technetwork/java/javase/terms/license/index.html):
> BY SELECTING THE "ACCEPT LICENSE AGREEMENT" (OR THE EQUIVALENT) BUTTON AND/<strong>OR BY USING THE SOFTWARE YOU ACKNOWLEDGE THAT YOU HAVE READ THE TERMS AND AGREE TO THEM</strong>.


_Enjoy it!_


[_Bonus_](http://le.kdecherf.com/post/21207105768/le-me-installing-jdk-on-three-servers)
