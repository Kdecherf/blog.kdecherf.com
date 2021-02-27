---
title: "Expose an OpenMediaVault instance on Nextcloud"
date: 2018-08-20T14:00:01+02:00
tags:
- openmediavault
- nextcloud
---

tl;dr Prefer CIFS to WebDAV for Nextcloud remote storages, when applicable.

Years ago I decided to make my own NAS server instead of buying an existing
appliance like Synology or QNAP[^1]. I installed OpenMediaVault on it to manage
the disks and shares. Sadly this system does not come natively with a web app
to browse your folders and files.

One could install Nextcloud on it to resolve this but in my case I already had
a Nextcloud instance somewhere else, so I wanted to mount my NAS as a remote
storage on it.

My first guess was to use WebDAV, a standard protocol which handles files
remotely using HTTP.  Nextcloud uses it internally for the desktop and mobile
apps and inter-instances communications.

You can enable the support of WebDAV on OpenMediaVault using plugins and
setting a user account with the needed permissions.

However the provided plugin does not work out-of-the-box with Nextcloud: it
does not guess the content type of files which prevents Nextcloud to register
correct file types on its side. You must edit
`/var/www/webdav/bootstrap/server.php` on OpenMediaVault with the following
changes:

``` php
$guessContentTypePlugin = new \OmvExtras\WebDAV\Sabre\GuessContentType();
$server->addPlugin($guessContentTypePlugin);
```

In my case I was also forced to provide a custom map to prevent some constraint
violations on Nextcloud's database[^2]:

``` php
$guessContentTypePlugin->extensionMap = array_merge($guessContentTypePlugin->extensionMap, [
      '123' => 'application/vnd.lotus-1-2-3',
      '3dml' => 'text/vnd.in3d.3dml',
      '3ds' => 'image/x-3ds',
      '3g2' => 'video/3gpp2',
      // ...
]);
```

Once you have configured the remote storage on the Nextcloud side, you can
launch full scans using `php occ files:scan`. You can optionally provide the
path to the remote folder you want to scan with `--path`.

And here I started to see the poor performance of WebDAV. My NAS exposes 78,000
files in 350 folders, accounting for 1.2 TB. A full scan took 1 hour and a half
on average:

``` bash
Starting scan for user 1 out of 1 (kdecherf)

   +---------+-------+--------------+
   | Folders | Files | Elapsed time |
   +---------+-------+--------------+
   | 346     | 77793 | 01:35:08     |
   +---------+-------+--------------+
```

I decided to explore another option: a CIFS mount. As the two servers have a
private connection between them, exposing a folder using CIFS is less of an
issue.

On the OpenMediaVault side there's no plugin to install, everything is handled
natively and the file types are correctly reported. Make sure to give adequate
permissions to the user you'll use for Nextcloud.

On the Nextcloud side, make sure `libsmbclient-php` is installed.

Using a CIFS mount, full scans take much less time:

``` bash
Starting scan for user 1 out of 1 (kdecherf)

   +---------+-------+--------------+
   | Folders | Files | Elapsed time |
   +---------+-------+--------------+
   | 346     | 77793 | 00:10:37     |
   +---------+-------+--------------+
```

_Enjoy!_

[^1]: To be honest, buy a Synology NAS if you can. Their DSM is awesome 😄
[^2]: Nextcloud has a possible bug when handling empty types
