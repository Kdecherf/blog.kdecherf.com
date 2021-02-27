Title: Remove cross-installed packages
Category: Blog
Tags: exherbo
Date: 2017-02-18 17:25

When I started my new job back in 2016 I needed to install Skype on my
workstation. As you can imagine my workstation uses Exherbo. Consequently, it was
necessary to build all dependencies using _i686_ architecture to be able to
install the old Skype client[^1].

I enabled _i686_ with the paludis target `i686-pc-linux-gnu` and began to
recompile a lot of packages. But things didn't go well and in the end, I was
unable to use the client. I ended up using a container just for this software.

But in the meantime some cross-compiled packages altered the system: some
*x86_64* files were replaced by their _i686_ counterparts and some alternatives were
broken. It was time to try to cleanup things.

First of all, we need to ignore some packages which are installed by default on
both targets. Save the following lines in a file named `ignore`:

```text
sys-kernel/linux-headers
sys-libs/glibc
sys-libs/libatomic
sys-libs/libgcc
sys-libs/libstdc++
```

Then, we need to reinstall all cross-compiled packages in the main target
(_`::installed` or *x86_64* here_) to touch colliding files:

```bash
cave resolve $(cave print-ids -m '*/*::i686-pc-linux-gnu' -f '%c/%p ') -x1 -Cs
```

Now that colliding files has been touched by `::installed` packages we can
uninstall all packages from `i686-pc-linux-gnu` except the system ones:

```bash
cave print-ids -m '*/*::i686-pc-linux-gnu' -f '=%c/%p-%v::i686-pc-linux-gnu\n' | \
grep -v -F -f ignore | head -n25 | \
xargs cave uninstall -Cs -mx -u '*/*' -u system -x1
```

Colliding files will remain untouched because the uninstalled packages don't own
them anymore thanks to the previous `cave resolve`.

Finally we must check the alternatives and revive broken ones:

```bash
find /etc/env.d/alternatives/ -type d -mindepth 1 -maxdepth 1 '!' -exec test -e "{}/_current" ';' -print
```

This command will print all broken symlinks found in the directory
`/etc/env.d/alternatives`.

Revive the broken alternatives using `eclectic alternatives update`, e.g. with systemd:

```bash
eclectic alternatives update init systemd
```

Thanks to [@sardemff7](https://twitter.com/Sardemff7) who helped me going
through this mess.

_Enjoy!_

[^1]: The _Skype for Linux Alpha_ program was not available yet
