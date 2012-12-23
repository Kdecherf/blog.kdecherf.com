---
layout: post
title: "OfflineIMAP and Sqlite3: «file is encrypted or is not a database»"
date: 2012-12-23 15:00
comments: true
categories: [Tips]
---

Have you already seen this error with OfflineIMAP and Sqlite3?

```
 Creating new Local Status db for Local-Gmail:INBOX-journal
 ERROR: While attempting to sync account 'GMail'
  file is encrypted or is not a database
```

Oh god, one of your databases is corrupted. This corruption is usually caused by an interruption during processing an account. But don't worry, the fix is quite simple.

<!-- more -->

First go on ``.offlineimap/Account-<YourAccountName>/LocalStatus-sqlite``, open the file ``INBOX`` with sqlite3 and type ``pragma integrity_check;`` (_and press Enter_):

```
SQLite version 3.7.14.1 2012-10-04 19:37:12
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite> pragma integrity_check;
```

Now you can quit with ``.quit`` and restart offlineimap.

_Enjoy!_
