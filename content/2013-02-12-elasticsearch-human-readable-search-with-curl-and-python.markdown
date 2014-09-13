Title: ElasticSearch: Human readable search with cURL and Python
Date: 2013-02-12 14:25
Category: Tips

At Clever Cloud, we use LogStash and ElasticSearch to index and make search on your logs. Since geeks are in love with command-line stuff, I made a little script to prettify the output of ES searches according to the LogStash fields.


The following scripts are intended to be used against LogStash-generated data but it gives you an idea on how to make your own "prettifier".

``` bash
#!/bin/bash

curl -XPOST -d "{\"query\":{\"bool\":{\"must\":[{\"query_string\":{\"default_field\":\"@source_host\",\"query\":\"$1\"}}],\"must_not\":[],\"should\":[]}},\"from\":0,\"size\":$LIMIT,\"sort\":[{\"@timestamp\":{\"order\":\"desc\"}}],\"facets\":{}}" http://yourelasticcluster:9200/yourindex/_search 2>/dev/null | prettify.py
```
> The script takes only one argument: the hostname (or IP if @source\_host is set with the client IP address).  
> Change `$LIMIT` according to your needs (_1,000 is a good value_).

``` python
#!/bin/env python

import json,sys
obj = json.load(sys.stdin)

for subobj in obj['hits']['hits']:
	print subobj['_source']['@timestamp'], " ", subobj['_source']['@source_host'], " ", subobj['_source']['@message']
```

> This tiny Python file will only print the fields *@timestamp*, *@source\_host* and *@message*.

And here the example output:

```
2013-02-12T00:35:22.158Z   myclient   Started Cleanup of Temporary Directories.
2013-02-12T00:35:22.157Z   myclient   Starting Cleanup of Temporary Directories...
2013-02-12T00:20:39.426Z   myclient   -- MARK --
2013-02-11T23:51:32.863Z   myclient   [Tue Feb 12 00:51:32.765323 2013] [fastcgi:error] [pid 1545:tid 140479406851840] [client 127.0.0.1:41038] FastCGI: comm with server "/var/www/php5/php5.internal" aborted: idle timeout (30 sec)
2013-02-11T23:40:39.198Z   myclient   -- MARK --
2013-02-11T23:20:39.130Z   myclient   -- MARK --
2013-02-11T23:00:39.035Z   myclient   -- MARK --
```

_Enjoy!_
