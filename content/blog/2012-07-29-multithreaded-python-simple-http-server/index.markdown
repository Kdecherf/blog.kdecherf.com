---
title: "Multithreaded Python Simple HTTP Server"
date: 2012-07-29T15:42:00+02:00
tags:
- python
---

Hey geeks, did you already have this conversation?

> _1st teammate:_ Do you have the ISO of [replace by a Linux distribution]?  
> _me_: Yep, go to mylovedlaptop.local:8000 and take it  
> _another teammate:_ Can I take it too?  
> _me_: Yep, go to mylovedlaptop.local:8001 and take it

This time is now over!

Let me make a little test for you:

``` bash
for ((i=0;i<5;i++)); do curl -s -0 http://localhost:8060/2G > ~/tmp/bigfile${i} &; done
```

Server output:
``` text
sakura.local - - [29/Jul/2012 15:41:01] "GET /2G HTTP/1.0" 200 -
sakura.local - - [29/Jul/2012 15:42:01] "GET /2G HTTP/1.0" 200 -
sakura.local - - [29/Jul/2012 15:43:05] "GET /2G HTTP/1.0" 200 -
sakura.local - - [29/Jul/2012 15:44:06] "GET /2G HTTP/1.0" 200 -
sakura.local - - [29/Jul/2012 15:45:07] "GET /2G HTTP/1.0" 200 -
```

The Python Simple HTTP Server can handle only one request a time. Yeah, it's really annoying to be constrained to start one _[python -m ]_`SimpleHTTPServer` for each person who wants to download this awesome big file at same time...

I found a [little Py script on the web](http://code.activestate.com/lists/python-list/284803/) to create a Multithreaded CGI Server. Now we have just a word to replace: 

``` python
#!/bin/env python

import SocketServer
import BaseHTTPServer
import SimpleHTTPServer

class ThreadingSimpleServer(SocketServer.ThreadingMixIn,
                   BaseHTTPServer.HTTPServer):
    pass

import sys

if sys.argv[1:]:
    port = int(sys.argv[1])
else:
    port = 8000

server = ThreadingSimpleServer(('', port), SimpleHTTPServer.SimpleHTTPRequestHandler)
try:
    while 1:
        sys.stdout.flush()
        server.handle_request()
except KeyboardInterrupt:
    print "Finished"
```

This script can take one argument like `python -m SimpleHTTPServer` to specify the port of the server.


And now all requests are served at same time:
``` text
sakura.local - - [29/Jul/2012 17:11:41] "GET /2G HTTP/1.0" 200 -
sakura.local - - [29/Jul/2012 17:11:41] "GET /2G HTTP/1.0" 200 -
sakura.local - - [29/Jul/2012 17:11:41] "GET /2G HTTP/1.0" 200 -
sakura.local - - [29/Jul/2012 17:11:41] "GET /2G HTTP/1.0" 200 -
sakura.local - - [29/Jul/2012 17:11:41] "GET /2G HTTP/1.0" 200 -
```

Please note that I've used a 2GB file for the example but this script is also useful for a local static files server used by more than one people.

_Enjoy it!_
