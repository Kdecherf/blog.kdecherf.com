Title: Mutt: a lightweight sidebar patch for heavy folders
Date: 2013-07-25 20:01
Category: Blog
Tags: mutt

<div class="alert-info">
  <strong>UPDATE 2015/10/01:</strong> patched for Mutt 1.5.24, removed 1.5.21 and moved the stuff to a GitHub repository
</div>

<div class="alert-info">
  <strong>UPDATE 2014/06/07:</strong> patched the patch for Mutt 1.5.23
</div>

Hey, I'm back after "several" busy days to show you a little tip of my virtual set _"Leave Gmail"_. In case you have several folders with a lot of emails (_more than 10,000 per folder_) like me and you want to use the [sidebar patch](http://www.lunar-linux.org/mutt-sidebar/) for your beloved Mutt, read this.

![Mutt Sidebar Patch]({attach}mutt-sidebar.png)
{: .image}

The sidebar patch adds a sidebar _[obviously]_ which shows a list of folders with some counters into Mutt.  
It works well but when you have folders with dozens of thousand emails your client will hang on each keystroke like during an IMAP sync. It's really annoying.

It is caused by the fact that the piece of code will check for emails on each keystroke by parsing all folders and file names. What could possibly go wrong?

I use the Maildir format for my accounts, this format is made of three subfolders for each email folder: `tmp/`, `new/` which contains new emails and `cur/` for all other emails.  
As my only need is to know when I have a new email in folders and I don't care about the total count of emails, I removed the part of the patch which parses the `cur/` subfolder.

Here is the change over the original patch:

``` diff
--- mutt1/mutt-1.5.21/buffy.c 2013-07-25 13:46:55.246056516 +0200
+++ mutt2/mutt-1.5.21/buffy.c 2013-07-25 14:09:43.799108645 +0200
@@ -429,34 +429,8 @@
   }
 
   closedir (dirp);
-  snprintf (path, sizeof (path), "%s/cur", mailbox->path);
-        
-  if ((dirp = opendir (path)) == NULL)
-  {   
-    mailbox->magic = 0;
-    return;
-  } 
-      
-  while ((de = readdir (dirp)) != NULL)
-  {
-    if (*de->d_name == '.')
-      continue;
-
-    if (!(p = strstr (de->d_name, ":2,")) || !strchr (p + 3, 'T')) {
-      mailbox->msgcount++;
-      if ((p = strstr (de->d_name, ":2,"))) {
-        if (!strchr (p + 3, 'T')) {
-          if (!strchr (p + 3, 'S'))
-            mailbox->msg_unread++;
-          if (strchr(p + 3, 'F'))
-            mailbox->msg_flagged++;
-        }
-      }
-    }
-  }
 
   mailbox->sb_last_checked = time(NULL);
-  closedir (dirp);
 }
 
 /* returns 1 if mailbox has new mail */ 
diff -u mutt1/mutt-1.5.21/init.h mutt2/mutt-1.5.21/init.h
--- mutt1/mutt-1.5.21/init.h  2013-07-25 13:46:55.424059514 +0200
+++ mutt2/mutt-1.5.21/init.h  2013-07-25 13:48:01.714176115 +0200
@@ -1985,7 +1985,7 @@
   ** .pp
   ** Should the sidebar shorten the path showed.
   */
-  {"sidebar_format", DT_STR, R_NONE, UL &SidebarFormat, UL "%B%?F? [%F]?%* %?N?%N/?%4S"},
+  {"sidebar_format", DT_STR, R_NONE, UL &SidebarFormat, UL "%B%?F? [%F]?%* %?N?%N?"},
   /*
   ** .pp
   ** Format string for the sidebar. The sequences `%N', `%F' and `%S'
```

My patches are available for version 1.5.23 and later on [Github](https://github.com/Kdecherf/mutt-lightweight-sidebar).

Now my sidebar doesn't hang and lets me play with my 492,885 emails.

_Enjoy!_
