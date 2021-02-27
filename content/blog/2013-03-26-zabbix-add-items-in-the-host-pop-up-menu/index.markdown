---
title: "Zabbix: Add items in the host pop up menu"
date: 2013-03-26T20:39:00+01:00
tags:
- zabbix
---

At Clever Cloud we use Zabbix to monitor our platform. When I see a problem I would like to be able to go to the host's settings or graphs from its pop up menu.  
Unfortunately, this feature is not available on the frontend.

![Zabbix]({attach}zabbix-1.png)
{: .image}

Well, the fix to add new items in this menu is quite simple. In the following figure, I add two links: "Settings" and "Graphs".


``` diff
--- js/init.js
+++ js/init.js
@@ -47,6 +47,8 @@
      // add go to links
      menu.push(createMenuHeader(t('Go to')));
      menu.push(createMenuItem(t('Latest data'), 'latest.php?hostid=' + menuData.hostid));
+     menu.push(createMenuItem(t('Graphs'), 'charts.php?hostid=' + menuData.hostid));
+     menu.push(createMenuItem(t('Settings'), 'hosts.php?form=update&hostid=' + menuData.hostid));
      if (menuData.hasInventory) {
         menu.push(createMenuItem(t('Host inventories'), 'hostinventories.php?hostid=' + menuData.hostid));
      }
```

And now we can take shortcuts to go to the Settings and Graphs pages:

![Zabbix]({attach}zabbix-2.png)
{: .image}


> Please note that this fix doesn't consider the user rights

_Enjoy!_
