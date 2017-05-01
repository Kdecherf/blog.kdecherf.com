Title: mbsync and Office 365
Category: Blog
Tags: mbsync, office 365
Date: 2017-05-01 23:55

I observed that offlineimap stops working correctly and starts seeing UID
validity issues quite often when syncing my Office 365 account. Considering that
a full folder resync is necessary to get rid of these issues I decided to give
[mbsync](http://isync.sourceforge.net/) a try.

After making the configuration of the tool, which is pretty straightforward, I
started it and… It failed with cryptic and random error messages like these:

```
IMAP error: bogus FETCH response
```

and

```
IMAP command 'UID FETCH x (BODY.PEEK[])' returned an error: UID
FETCH x (BODY.* y FETCH (BODY[] {z}
```

While trying to find any resource about these errors I [found a note](https://wiki.archlinux.org/index.php/Isync#Exchange_2003) on the
isync page of ArchLinux's Wiki. It says that Microsoft Exchange 2003 server is
unable to handle concurrent IMAP commands, which is the default behavior of
mbsync. You must add the following line to the mbsync configuration to disable
this feature:

```
PipelineDepth 1
```

It appears that this solution also solves the issue with Office 365.

_Enjoy!_
