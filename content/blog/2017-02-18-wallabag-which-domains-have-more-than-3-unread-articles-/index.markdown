---
title: "Wallabag: which domains have more than 3 unread articles?"
date: 2017-02-18T18:45:00+01:00
tags:
- wallabag
- postgresql
---

Here's a little SQL command if you are using Wallabag with a PostgreSQL database
and you want to know which domains have more than 3 unread articles:

```sql
SELECT array_to_string(
         regexp_matches(url,'https?://(?:[a-z0-9-]+\.)*([a-z0-9-]+\.[a-z0-9-]+)/.*'),
         ''
       ) AS domain,
       COUNT(*) AS count
FROM wallabag_entry
WHERE is_archived=false
GROUP BY domain
HAVING COUNT(*)>3
ORDER BY count DESC;
```

This command will output something like this:

```text
         domain         | count
------------------------+-------
 nationalgeographic.com |    26
 medium.com             |    18
 lemonde.fr             |    15
 petapixel.com          |    13
 wired.com              |    10
```

_Enjoy!_
