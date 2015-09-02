Title: Zabbix: HTTP Return Code Monitoring Without Web Monitoring
Date: 2012-12-03 10:05
Category: Tips 
Tags: zabbix

Several days ago I wanted to monitor the HTTP Return Code of an API in Zabbix. My first attempt with Scenarios in Web Monitoring was a fail.

The proper way to do it is to use [generated items](http://www.zabbix.com/documentation/2.0/manual/web_monitoring/items#scenario_items) for each Scenario. But if you want to monitor a resource with only one step, you can also use the following tip:


First, add a new item to your host with this key:

```
web.page.regexp[host,path,80,HTTP/1\.1.*,12]
```

Replace `host` by the hostname or the ip, `path` by the resource path to monitor without the leading '/' and replace `80` by a specific port if the server uses another port.

Then, you can create a trigger for this item with the following expression:

```
(({hostortemplatename:web.page.regexp[host,path,80,HTTP/1\.1.*,12].regexp(HTTP/1.1\ 200)})#1)
```

_(if you want to trigger an alert when the return code is not 200)_

_Enjoy!_
