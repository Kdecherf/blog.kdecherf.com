---
title: "Calibre and the invisible e-reader"
date: 2017-02-18T17:22:00+01:00
tags:
- calibre
- linux
---

I decided to give a new try to Calibre a few months ago after buying several
O'reilly ebooks. Mainly because my workflow to synchronize my e-reader was to use
`rsync` and I didn't have any easy way to merge several formats of the same
ebook nor tracking their reading state.

Luckily one of the features of Calibre is to auto-mount plugged e-readers saving
you a manual mount. The sad part was that nothing happened when I plugged my
Sony PRS-T2 even though the two were supposed to be compatible.

`strace` to the rescue! After digging into I/O-related system calls I found that
Calibre was parsing `/sys/devices` directory and doing some things with other sysfs
folders to find compatible devices. Oddly my laptop didn't populate the correct
folders when I plugged my device. After losing several hours on this issue,
someone pointed me to the sysfs layout configuration in the kernel. After
checking my configuration I found that `CONFIG_SYSFS_DEPRECATED` and
`CONFIG_SYSFS_DEPRECATED_V2` were enabled. These options instruct the kernel to
use the sysfs layout used decades ago instead of the _new_ one. After disabling
these two options Calibre started to automount the plugged e-reader.

To be honest you should not be affected by this issue since these options are
disabled by default since at least 2006.

_Enjoy!_
