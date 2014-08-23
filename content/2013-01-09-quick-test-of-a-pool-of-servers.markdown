Title: Quick test of a pool of webservers
Date: 2013-01-09 20:40
Category: Tips

> Hm, this website is down... But wait, it has a bunch of servers!

Yesterday mutt hanged when opening PGP-signed emails because the default keyserver was partially down. Partially? GPG was taking always the same _[down]_ server although there is a pool of a dozen of servers for the given address.


I used the following oneliner to test if the webserver of each address of the domain (_which using DNS Round-Robin_) is up or not:

``` bash
#!/bin/sh

( route -6 | grep "^::/0" | awk '{print $NF}' | grep -v 'lo' ) 2>&1 >/dev/null  && HOSTOPTS="" || HOSTOPTS="-t A" ; for i in $( (host $HOSTOPTS $1 || (echo "$1 not found" 1>&2 && exit 1)) | grep -E "has (IPv6 )?address" | awk -F' ' '{print $NF}') ; do CURLOPTS=(); echo "$i" | grep ":" 2>&1 >/dev/null && CURLOPTS+=( -g "http://[$i]" ) || CURLOPTS+=( http://$i ) ; curl -H"Host: $1" -s -m3 ${CURLOPTS[@]} 2>&1 >/dev/null && echo $i is up || echo $i is down ; done
```

> _Note: this script will automatically skip IPv6 addresses if no external route is found for it_


Example:
```
$ isup keys.gnupg.net
213.133.103.71 is up
131.155.141.70 is up
130.133.110.62 is up
109.230.243.93 is up
92.24.32.132 is up
91.121.176.163 is down
88.198.24.12 is up
66.109.111.12 is up
37.59.123.209 is up
217.86.143.161 is up
2001:610:1:40cc::9164:b9e5 is up
2001:4978:234::b is up
2001:41d0:1:c2e2:4e72:b9ff:fe4f:422 is up
2607:5300:60:2885::1 is down
2001:470:1f0a:5d7::2 is up
2001:1418:1d7:1::1 is up
2001:470:7:6ad::2 is up
2001:6f8:1c3c:babe::62:1 is up
2001:470:b2a7:1:225:90ff:fe93:e9fc is up
2600:3c02::2:7004 is up
```

_Enjoy!_
