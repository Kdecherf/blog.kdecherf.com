Title: Auditing passwords on password store
Category: Blog
Tags: pass
Date: 2017-11-01 23:09

Five years ago, I decided to give a try to [password store][1] for managing my
passwords on top of Git and GPG. Five years later I still use it for storing
hundreds of passwords.

Even though this kind of tool makes the management of passwords easier and
reduces the risk of reuse, there's still something that must be done manually:
password rotations. You may want to rotate passwords because one site recently
suffered from a leak or simply because you don't want to keep using too old
passwords.

But how can you easily see the last time your passwords were updated?

_@jbfavre_ [tweeted][2] a few months ago [a blog post][3] talking about password
rotation with pass. However the given script has a major culprit: it relies on
the last modification done on a file, whatever the change was. Here are some
cases that count as change and consequently impact the returned date for a
password:

 * Renaming or moving a file
 * Editing a file without editing the password (_login, …_)
 * Reencrypting the whole store

How can we improve that?

Two years ago, someone [posted a script][4] on the pass mailing list. This
script basically retrieves all revisions of a password and checks which of them
actually changed the password (_the first line_). Someone else quickly
[suggested][5] the use of Git textconv and blame to directly find the last
revision which changed the first line.

I decided to explore this last idea and write a script to do this thing while
taking advantage of the new pass extension system: no more file patching!

Say hello to pass-report: [https://github.com/Kdecherf/pass-report][6]

This script will output the date and relative age of the last change for a given
password or all of them. Additionally, it can output an indication of their
length, which can help you easily find really short passwords.

![pass-report]({attach}screenshot.png)
{: .image}

One must note that as Git needs to decrypt passwords this script may take a
while to print the report for all passwords.

You may also be interested in another extension which helps you actually rotate
passwords: [https://github.com/roddhjav/pass-update][7]

_Enjoy!_

[1]: https://www.passwordstore.org
[2]: https://twitter.com/jbfavre/status/835768073558831104
[3]: https://blog.steve.fi/rotating_passwords.html
[4]: https://lists.zx2c4.com/pipermail/password-store/2015-July/001638.html
[5]: https://lists.zx2c4.com/pipermail/password-store/2015-July/001641.html
[6]: https://github.com/Kdecherf/pass-report
[7]: https://github.com/roddhjav/pass-update
