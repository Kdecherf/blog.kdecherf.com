---
layout: post
title: "Incremental backup with rsync"
date: 2012-06-30 16:03 
comments: true
published: false
categories: [Articles] 
---

Hello World,

It's most a tip than an article but today I create a little script for you to make incremental backups using rsync.  
An incremental backup is a backup that only contains modified files since the last backup. In this article I invert this principle to backup in a separate folder old versions of a modified or deleted file.

For this script we only need three options of rsync:

  * `--delete` for deletion of useless files in the destination folder
  * `--backup` to make backup of modified or deleted files in the destination folder (mandatory for using `--backup-dir`)
  * `--backup-dir` to tell to rsync which folder to use for backuped files

> Note: If you don't use `--delete`, rsync will keep all deleted files in the destination folder.

So, the complete command is like that:

```
rsync -a -b --delete --backup-dir=mydir source dest
```
> I love `-a` option and `-b` is the short option of `--backup`  
> Note: To prevent misconfiguration, you should use absolute path for `--backup-dir`  
> Note 2: You can use `-z` if you want to compress data during the transfer

For our incremental backup we want to backup files using the backup date, so we use `date` command in the rsync command, like that:

``` bash
CURBCK=$(date +%Y%m%d)
ABSCURBCK=/my/path/to/$CURBCK
rsync -a -b --delete --backup-dir=$ABSCURBCK source/ dest
```
In this example I assume that we call this script only once a day (*the backup folder is named using the form YYYYMMDD*), you can replace `%Y%m%d` by `%Y%m%d%H%M%S` to be more specific (*YYYYMMDDHHMMSS*).

Test of this bunch of commands:
```
# in source folder
$ ls
file
$ sha1sum
827506be8bdb09a5f3c463ad6aa45ca66d7bccbf

# We make a sync and verify file in the dest file
$ ls
file
$ sha1sum file
827506be8bdb09a5f3c463ad6aa45ca66d7bccbf

# We modify the file and make a new sync
$ sha1sum source/file backup/**/file
c2304cf35abdb7a8c79d29737accc75de6db495a  source/file
c2304cf35abdb7a8c79d29737accc75de6db495a  backup/current/file
827506be8bdb09a5f3c463ad6aa45ca66d7bccbf  backup/20120309201330/file

# We delete the file
$ sha1sum source/file backup/**/file
sha1sum: source/file: No such file or directory
827506be8bdb09a5f3c463ad6aa45ca66d7bccbf  backup/20120309201330/file
c2304cf35abdb7a8c79d29737accc75de6db495a  backup/20120309201456/file

```


Feel free to add scripts to compress backup files.

_Enjoy it!_

