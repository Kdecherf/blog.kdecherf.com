Title: OfflineIMAP: Periodically fetch emails with systemd's timers
Date: 2012-12-23 17:25
Category: Tips

When I switched from Gmail web interface to Mutt+OfflineIMAP, I used the ``autorefresh`` feature of OfflineIMAP.

But after only few hours of run, the process consumes more than a gigabyte of memory while it consumes only ~300MB on the first fetch.

A lot of people prefer to use a cronjob to replace ``autorefresh`` and execute the process only once on each fetch, but since I'm using systemd I can directly use a timer to do the same thing.

First of all, we need to write a little service for offlineimap, named `offlineimap.service`:

``` ini
[Unit]
Description=OfflineIMAP Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/offlineimap
```

**Note:** If you use gpg-agent to retrieve your passwords, add this line in the ``Service`` section: ``EnvironmentFile=/path/to/your/.gpg-agent-info``

**Note 2:** If you use a systemd service to start gpg-agent[ref]There is an example available on a [previous post](/blog/2012/11/06/mount-a-luks-partition-with-a-password-protected-gpg-encrypted-key-using-systemd/)[/ref], add the following line in the ``Unit`` section: ``Requires=gpg-agent.service``


The timer is shorter and named `offlineimap.timer`:

``` ini
[Timer]
OnUnitInactiveSec=120s
Unit=offlineimap.service
```

Offlineimap will run 2 minutes after each deactivation of the unit (_``OnUnitInactiveSec``_) with this timer.

**Note:** You can write another timer with a different interval if you have slow connections while traveling.

After adding these files you can start the timer with ``systemctl --user start offlineimap.timer``.

You must start the service for the first run after starting the timer with ``systemctl --user start offlineimap.service`` since the timer activates the service after the **last deactivation**.

**General Note:** Please be careful when you shutdown your computer. If offlineimap is running, there is a high probability that one of the databases become corrupted.

_Enjoy!_
