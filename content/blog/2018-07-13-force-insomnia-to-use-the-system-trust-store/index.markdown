---
title: "Force Insomnia to use the system trust store"
date: 2018-07-13T12:58:26+02:00
tags:
- x509
- insomnia
- nodejs
---

<div class="alert-warn">
   <strong>PSA:</strong> Electron developers and others, please stop making use
   of custom CA a PITA by embedding your own trust store and stop advicing
   users to disable SSL validation when they have errors.
</div>

At work we emit X.509 certificates from several internal certificate
authorities. When you play with internal CA you must update the trusted store
of your system or your application in order to get valid interactions.

On Linux you may add bundles to the system trust store with the help of
`update-ca-certificates`. Your internal CA will be thus trusted by tools like
`curl`, `wget` or even PHP applications.

However some stacks ignore the system trust store and use their own, like Java
and Node.js. For the latter, starting with `7.3.0`, you can add extra CA with
the environment variable `NODE_EXTRA_CA_CERTS`.

Cool but it appears that Insomnia —a REST client— and more generally every
Electron app ignore this variable, at best[^1]. And you end with that thing:

![Insomnia TLS Error](insomnia1.png)

As you can see, the workaround proposed by the application is to simply disable
SSL validation. What a brilliant idea.

While wandering between tabs and swearing I saw something interesting in the
_Timeline_ tab:

![Insomnia Timeline tab](insomnia2.png)

The good news is that Insomnia uses `curl` to make requests, the bad news is
that they decided to override the default behavior of `curl` (_using the system
trust store_) with an embedded trust store which is copied into
`/tmp/insomnia_x/y.pem`.

After a quick check, it appears that _x_ is the version number and _y_ the
trust store bundle name which is [provided in `cacert.js`][1].

Now we need to override this file with the system store. If you use _systemd_
on your device you can use `systemd-tmpfiles` to achieve that.

Let's create a file `/usr/lib/tmpfiles.d/insomnia.conf` with the following content:

``` text
L+ /tmp/insomnia_5.16.6/2017-09-20.pem - - - - /etc/ssl/certs/ca-certificates.crt
```

Some notes:

* In this example, I took the references for Insomnia 5.16.6. You should adapt
  regarding to your version.
* `L+` instructs `systemd` to remove the target file if it already exists
* `systemd-tmpfiles` will execute this file at each boot

Delete the folder `/tmp/insomnia_*` before rebooting or executing the following
command. If you miss this step, the folder will still be writable by Insomnia.

If you want to execute this file without rebooting, type the following command:

``` text
systemd-tmpfiles --create /usr/lib/tmpfiles.d/insomnia.conf
```

As the file used by Insomnia is now a symlink to the system trust store, it
will validate all requests against it, enabling you to have correct validation
with custom CA.

_Enjoy!_

[^1]: I experienced segfaults while playing with this variable

[1]: https://github.com/getinsomnia/insomnia/blob/develop/packages/insomnia-app/app/network/cacert.js
