Title: This blog is served by a Raspberry Pi
Date: 2013-01-11 17:23
Category: Blog
Yesterday I switched the primary source of my blog to _Kaho_, my Raspberry Pi behind a broadband connection.

> _Why? Just for fun._

![You are here]({attach}rasp-you-are-here.jpg)
{: .image}


In fact there is another server between you and the Raspberry Pi as illustrated below to prevent overloads and downtimes (_fonts are served by the main server to save bandwidth_):

![Architecture]({attach}architecture.png)
{: .image}

Since I switched my blog to [Octopress](http://octopress.org), the webserver is only serving static files so I don't need a lot of resources to host it. Nginx is enough.

I made some load tests with [siege](http://www.joedog.org/siege-home/) to know how much connections the raspberry pi and my connection can handle in this configuration (_serving small static files_).


### HAProxy configuration

As I said, there is a frontend server which dispatches requests on my Raspberry Pi or the local server according to its availability.

I use this configuration:

```
frontend webfront
        // ...
        acl is_blog_kdecherf_com hdr_dom(host) -i blog.kdecherf.com
        acl is_fonts path_beg /fonts

        use_backend cluster_local if is_blog_kdecherf_com is_fonts
        use_backend cluster_blog if is_blog_kdecherf_com

backend cluster_blog
        mode http
        option  httplog
        option httpclose        #Disable keepalive
        option forwardfor
        balance first
        server  kaho raspip:8000 maxconn 20 check inter 5000 rise 2 fall 5
        server  shaolan 127.0.0.1:8000 check inter 2000 rise 2 fall 5

// ...
```

In this configuration, requests on `/fonts` are always forwarded to the local webserver (_to limit latency due to the size of files_) but other requests are forwarded to the Raspberry Pi within the limit of 20 concurrent sessions (_thanks to `balance first` available in HAProxy 1.5_).


### Broadband connection limit

My first test was done with 5 concurrent connections, there is no load (_glances uses 17% of CPU_) and the throughput is low:

```
$ siege -f urls.txt -i -c 5 -t 1m
Lifting the server siege...      done.
Transactions:                    486 hits
Availability:                  99.79 %
Elapsed time:                  59.14 secs
Data transferred:               2.05 MB
Response time:                  0.10 secs
Transaction rate:               8.22 trans/sec
Throughput:                     0.03 MB/sec
Concurrency:                    0.81
Successful transactions:         486
Failed transactions:               1
Longest transaction:            3.16
Shortest transaction:           0.06
```

![5 concurrent connections]({attach}rasp-5c.png)
{: .image}


The number of concurrent connections was increased to 15 for the second test, results are good too:

```
$ siege -f urls.txt -i -c 15 -t 1m
Lifting the server siege...      done.
Transactions:                   1548 hits
Availability:                  99.49 %
Elapsed time:                  59.33 secs
Data transferred:               6.33 MB
Response time:                  0.09 secs
Transaction rate:              26.09 trans/sec
Throughput:                     0.11 MB/sec
Concurrency:                   2.23
Successful transactions:        1548
Failed transactions:               8
Longest transaction:            0.14
Shortest transaction:           0.07
```

![15 concurrent connections]({attach}rasp-15c.png)
{: .image}

After these tests, my connection can handle ~40 concurrent connections but can raspberry pi handle more connections?


### Local test

Two other tests were done on my local network with 50 and 150 concurrent connections.

The Raspberry Pi had no problem to serve 50 concurrent connections as you can see:

```
$ siege -f urls.txt -i -c 50 -t 1m
Lifting the server siege...      done.
Transactions:             5552 hits
Availability:           100.00 %
Elapsed time:            59.34 secs
Data transferred:        22.91 MB
Response time:            0.03 secs
Transaction rate:        93.56 trans/sec
Throughput:            0.39 MB/sec
Concurrency:              3.24
Successful transactions:        5552
Failed transactions:            0
Longest transaction:         0.81
Shortest transaction:           0.00
```

![50 concurrent connections]({attach}rasp-50c.png)
{: .image}


The response time is _higher_ (_470ms is still a really good response time_) with 150 concurrent connections and the CPU is full:

```
$ siege -f urls.txt -i -c 150 -t 1m
Lifting the server siege...      done.
Transactions:             9156 hits
Availability:           100.00 %
Elapsed time:            59.84 secs
Data transferred:        37.75 MB
Response time:            0.47 secs
Transaction rate:       153.01 trans/sec
Throughput:            0.63 MB/sec
Concurrency:             72.57
Successful transactions:        9156
Failed transactions:            0
Longest transaction:         1.03
Shortest transaction:           0.00
```

![150 concurrent connections]({attach}rasp-150c.png)
{: .image}

So in this configuration the Raspberry Pi can handle more than 150 rps!

> Yes, I keep a _SPOF_ if the loadbalancer becomes unavailable but this configuration is just for the fun of self-hosting on a Raspberry Pi.

_Enjoy!_
