Title: How not to migrate emails between Gmail accounts
Category: Articles
Tags: offlineimap, gmail
Date: 2015-09-12 15:58

I had several debugging sessions this week and it produced really interesting findings which I will share here. I begin with a mishap that could have turned into a disaster and data loss: email migration.

Yesterday I finally decided to migrate all the remaining emails of my Gmail account to my main email account —which is another Gmail account thanks to Google Apps— with the help of [offlineimap](http://offlineimap.org/>). Nothing fancy until I found a weird issue during the actual upload of the emails.

The process here was to move files from one `[Gmail]/All Mail` folder to another on my laptop and synchronize the latter with offlineimap. I expected offlineimap to upload more than 4,000 emails but it eventually sent less than a thousand without any error. A quick check using the special filter `rfc822msgid` confirmed that a lot of emails were actually missing.

Don't panic, let's engage the debug mode of offlineimap. `offlineimap -d maildir` shows that it scanned and found 401,168 messages whereas the folder counts 405,042 valid emails. Well, let's check the [scan routine](https://github.com/OfflineIMAP/offlineimap/blob/master/offlineimap/folder/Maildir.py#L145>) of the software:

``` python hl_lines="22"
def _scanfolder(self, min_date=None, min_uid=None):

    maxsize = self.getmaxsize()

    retval = {}
    files = []
    nouidcounter = -1          # Messages without UIDs get negative UIDs.
    for dirannex in ['new', 'cur']:
        fulldirname = os.path.join(self.getfullname(), dirannex)
        files.extend((dirannex, filename) for
                     filename in os.listdir(fulldirname))

    date_excludees = {}
    for dirannex, filename in files:
        # We store just dirannex and filename, ie 'cur/123...'
        filepath = os.path.join(dirannex, filename)
        # Check maxsize if this message should be considered.
        if maxsize and (os.path.getsize(os.path.join(
                    self.getfullname(), filepath)) > maxsize):
            continue

        (prefix, uid, fmd5, flags) = self._parse_filename(filename)

        # ...snipped code...
```

We note that offlineimap is parsing filenames to extract some metadata like... UID and folder md5 hash (`FMD5`). Let's see the synopsis of the function `_parse_filename`:

> Returns a messages file name components
> 
> Receives the file name (without path) of a msg.  Usual format is  
> '<%d_%d.%d.%s>,U=<%d>,FMD5=<%s>:2,<FLAGS>' (pointy brackets  
> denoting the various components).

`U=` represents the UID of the message on the remote side and `FMD5` is the md5 hash of the folder name. For example the FMD5 of `[Gmail].All Mail` (_the `/` becomes a `.` on the local side_) is `844bb96d088d057aa1b32ac1fbc67b56`.

It is assumed that the pair `<UID,FMD5>` must be unique in one given folder. Wait, wait... Now I realize what's happening here. Remember, I've just moved the files from one folder to another and these folders have the same name, so do their FMD5. There is a UID conflict right now. Let's confirm that.

For safety before and after the operation I scanned the two folders in order to produce a file with list of files and sha1 sums to easily recognize filename change and other stuff. I will use them to check the conflict.

``` bash
~ % cat ~/sha1-all| cut -d, -f2 | sort | uniq -c | sort -nr | while read num uid ; do if [ $num -gt 1 ] ; then echo $uid ; fi ; done | wc -l
3874
```

The command above extracts the UIDs (_using the delimiter `,`_) from the list of files generated earlier, sorts them and counts the occurences. Finally we print the UIDs that have more than one occurence. We count 3,874 duplicate UIDs. 401,168 + 3,874 = **405,042**, it fits.

Now how do I fix it and what could I do to avoid this?  
Let's go back to the synopsis of `_parse_filename`:

> If FMD5 does not correspond with the current folder MD5, we will  
> return None for the UID & FMD5 (as it is not valid in this  
> folder).  If UID or FMD5 can not be detected, we return **None**  
> for the respective element.  If flags are empty or cannot be  
> detected, we return an empty flags list.

So if I change the FMD5 of affected emails offlineimap will invalidate the UIDs and treat them as new messages to upload.

At this point if you did not move the files yet you just need to rename the files during the move (_you can adjust the fix below to perform that_). Otherwise I hope you made a list of files before moving them.

I assume that I have the files `~/sha1-gmail` and `~/sha1-all` which contain respectively the sum and the path of files of my gmail account and my new account. These files can be generated using a one-liner like this one:
``` plain
cd .oldmail/\[Gmail\].All\ Mail ; find -type f -exec sha1sum {} \; >> ~/sha1-gmail
```

Using the command seen earlier, I will save the list of duplicate UIDs: instead of `echo $uid` I use `echo "$uid," >> ~/uid-to-fix`.  
**Note:** The comma is very important here, it will ensure that we will not match partial UIDs.

Now that I have the list of UIDs to fix, I check them against the file `~/sha1-gmail` to have the original filenames to fix.  
**Note:** Beware that when making list of sha1 sums with `sha1sum` the filename is printed out along with its path according to the initial call.

Here is my _nearly_ one-liner to fix the filenames:

``` bash
grep -f ~/uid-to-fix ~/sha1-gmail | while read sum file ; do
   nfile=$(echo ${file} | sed s/844bb96d088d057aa1b32ac1fbc67b56/b13603b2eaca0fbab67bbe77f7c2c282/)
   mv ~/.mail/\[Gmail\].All\ Mail/{${file},${nfile}}
done
```

As long as offlineimap just ignored the conflict files, filenames remained the same in the new folder so using the filenames from `~/sha1-gmail` will be enough.

First, I extract the filenames matching the UIDs contained in the file (`-f`) `~/uid-to-fix` and split the output into two variables: `sum` and `file`.  
Next, I prepare the new filename, here I change the original FMD5 with the md5 hash of the string _"InvalidFolderHash"_ (`b13603b2eaca0fbab67bbe77f7c2c282`). In my case the files in the list of sums had the form `{cur,new}/{filename}` so I must be in the correct folder or set the correct absolute path before renaming files. And finally I rename the files.

Now we can re-run offlineimap and confirm that it uploads the missing emails:

``` plain
...
 Copy message -2 (1 of 3874) Local-Kdecherf:[Gmail].All Mail -> Remote-Kdecherf
...
```

It works!

_Enjoy!_
