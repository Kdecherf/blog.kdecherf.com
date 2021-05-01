---
title: "Oracle, I download your JDK by eating magic cookies"
date: 2012-04-12T21:15:00+02:00
tags:
- java
---

{{< alertbox "info" "UPDATE 2014/07/18" >}}
  Replacing <code>gpw_e24</code> by <code>oraclelicense</code>, easier.
{{< /alertbox >}}

{{< alertbox "info" "UPDATE 2013/05/26">}}
  As noted by <em>frog end</em> and <em>Kip</em> in comments, wget 1.12 (<em>mainly on CentOS systems</em>) is unable to handle SAN SSL certificates (<em>Subject Alternative Name</em>) and will fail on <code>edelivery.oracle.com</code>. Use <code>--no-check-certificate</code> to avoid this issue.
{{< /alertbox >}}

Today, I had to install the <span style="text-decoration:line-through;">Sun</span>Oracle JDK on some servers, so I visited the [JDK download page](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) to retrieve the direct download link for `wget` on each server:
```
$ wget http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz
```

After launching the command, the server redirects me to a 5K HTML file:
```
Location: http://download.oracle.com/errors/download-fail-1505220.html [following]
```

WAIT, WHAT? I can't download the file if I don't visit their download page to accept the OTN license.


Challenge accepted, I'm going to play with requests... What happens when I click on the archive link?

First request:
```
Request URL:http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz
Request Method:GET
Cookies: notice_preferences=2:-; s_cc=true; oraclelicense=accept-securebackup-cookie; s_nr=1405635054064; gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk7-downloads-1880260.html; s_sq=%5B%5BB%5D%5D
```

Okay, trying to play with cookie values (_I deleted the useless values_):
```
$ wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz

--2014-07-18 00:15:33--  http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz
Resolving download.oracle.com (download.oracle.com)... 213.152.6.72, 158.255.97.136
Connecting to download.oracle.com (download.oracle.com)|213.152.6.72|:80... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://edelivery.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz [following]
--2014-07-18 00:15:33--  https://edelivery.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz
Resolving edelivery.oracle.com (edelivery.oracle.com)... 23.214.45.142
Connecting to edelivery.oracle.com (edelivery.oracle.com)|23.214.45.142|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz?AuthParam=- [following]
--2014-07-18 00:15:35--  http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz?AuthParam=-
Connecting to download.oracle.com (download.oracle.com)|213.152.6.72|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 142384385 (136M) [application/x-gzip]
Saving to: ‘jdk-7u65-linux-x64.tar.gz’
```

Fuck Yea.

According to the [OTN BCL document for Java SE](http://www.oracle.com/technetwork/java/javase/terms/license/index.html):
> BY SELECTING THE "ACCEPT LICENSE AGREEMENT" (OR THE EQUIVALENT) BUTTON AND/<strong>OR BY USING THE SOFTWARE YOU ACKNOWLEDGE THAT YOU HAVE READ THE TERMS AND AGREE TO THEM</strong>.


_Enjoy it!_


[_Bonus_]({{< ref "/le-kdecherf/2012-04-16-le-me-installing-jdk-on-three-servers/index.markdown" >}})
