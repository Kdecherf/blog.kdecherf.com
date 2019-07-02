Title: OpenMediaVault and the missing RAID array
Category: Blog
Tags: openmediavault
Date: 2019-07-02 21:57:35

Today while trying to update some softwares on my NAS server I had issues with
Debian Jessie's missing repositories. I though it was the right time to
upgrade to OpenMediaVault 4, which was released last year and features a Debian
Stretch.

The upgrade of packages went smoothly but as usual with this kind of upgrade,
problems came after the reboot: the server became irresponsive.

Time to find a VGA cable and dig into it. The server was stuck in maintenance
mode saying that the systemd unit responsible for mounting the data disk timed
out, all subsequent dependencies failed too (_other data mount points_). I
checked the status of the array, it was there and healthy but `blkid` was not
returning it at all.

<div class="alert-warn">
  Don't forget to make backups before playing with your drives following a failure.
</div>

Trying to mount the array by hand gave me this pretty message:

```
mount: /dev/md0: more filesystems detected. This should not happen,
       use -t  to explicitly specify the filesystem type or
       use wipefs(8) to clean up the device.
```

Well… Executing `wipefs /dev/md0` showed that there was a residual ZFS filesystem down there:

```
offset               type
----------------------------------------------------------------
0x2ba993ff000        zfs_member   [filesystem]

0x438                ext4   [filesystem]
[…]
```

I tried FreeNAS and a ZFS pool before installing OpenMediaVault and it seems
that now the system is not really happy with that. Folks usually advise to make
a backup of data, wipe all filesystem signatures from the disk and create the
array again.

As I was quite unsatisfied with this method, I decided to give a try to just
wiping out the ZFS signature with `wipefs -b -o 0x2ba993ff000 /dev/md0`.

> `-b` here creates a backup of the deleted bits, can be useful if things go
wrong.

Making a new `wipefs /dev/md0` call showed the `zfs_member` filesystem
signature again, but with another offset:

```
offset               type
----------------------------------------------------------------
0x2ba993fe000        zfs_member   [filesystem]

0x438                ext4   [filesystem]
[…]
```

I checked dirtily how many ZFS signatures were still on the drive:

```
hexdump -s 0x2ba99000000 -C /dev/md0 | grep "0c b1 ba"
```

This command printed out more than 40 signatures. I decided not to automate the
wipe of these signatures and wiped out the zfs signatures one by one.

After 25 signatures wiped, `wipefs` stopped showing ZFS and the system
automatically mounted the drive.

I made a last reboot to check that everything was ok and it was already time to
take lunch.

_Enjoy!_
