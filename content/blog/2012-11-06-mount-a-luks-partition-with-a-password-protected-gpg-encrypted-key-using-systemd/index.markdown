---
title: "Mount a LUKS partition with a password-protected GPG-encrypted key using systemd"
date: 2012-11-06T22:12:00+01:00
tags:
- luks
- systemd
- linux
---

I recently took a good resolution for my laptop: increase the security of some sensitive data using LUKS.
Because I'm using a password-protected gpg-encrypted key, I can't use any automatic mount tool like dracut or automount so I use a bunch of systemd service files.

_**Note:** I'm using the user part of systemd, but this article is not about its configuration._


### GPG-Agent

The first tool I need is `gpg-agent` which is not system-wide, so I create an unit file named `gpg-agent.service`:

``` ini
[Unit]
Description=GPG Agent Daemon

[Service]
ExecStart=/usr/bin/gpg-agent --daemon --no-detach
ExecReload=/bin/kill -HUP $MAINPID
Type=forking

[Install]
WantedBy=default.target
```

If you need the SSH Agent support, append `--enable-ssh-support` to `ExecStart`.  
`ExecReload` is used to clean the passphrases cache when you want (_reload gpg-agent with: `systemctl --user reload gpg-agent.service`_).

_**Note:** Don't forget to append `use-agent` in `~/.gnupg/gpg.conf` and customize the agent configuration with `~/.gnupg/gpg-agent.conf`_


### LUKS

I've found [a script](http://www.saout.de/pipermail/dm-crypt/2011-January/001467.html) for mounting a LUKS partition with automount. I've customized it for my own use:

``` bash
#!/bin/sh

key="{keyname}"

# The cryptsetup tool from the package of the same name
CRYPTSETUP=/sbin/cryptsetup

# This is the raw device that we will mount
mount_device=/dev/{device}

# This is the encryption key file, encrypted using gpg
key_file={keypath}

# Mount options for the encrypted fileystem
mount_opts="-t ext4 -o defaults,noatime,nodiratime,users,owner,exec"

# The mapped block device
crypt_device=/dev/mapper/$key

# Give up if there is no key or setup tool
# [ -r $key_file ] || exit 0
[ -x $CRYPTSETUP ] || exit 1

# If there is an encrypted device mapped in already, it must be from a
# previous mount. It may be out-of-date so remove it now.
[ -b $crypt_device ] && sudo $CRYPTSETUP remove $key

# Give up if the raw device doesn't have a LUKS header
sudo $CRYPTSETUP isLuks $mount_device || exit 2

# Open the encrypted block device
gpg --batch --decrypt $key_file 2>/dev/null | sudo $CRYPTSETUP -d - luksOpen $mount_device $key >& /dev/null || exit 3

# If we ended up with a block device, mount it
if [ -b $crypt_device ]; then
  sudo mount $mount_opts /dev/mapper/$key {mountpath}
fi
exit 0
```
> **{keyname}:** Name of the LUKS device  
> **{device}:** LUKS disk device  
> **{keypath}:** absolute path of the gpg-encrypted key to unlock the LUKS device  
> **{mountpath}:** absolute path of the mount point

_**Note:** I'm using sudo to be able to call cryptsetup and mount with root privileges (without password)._

Now with this script, we can make a new unit file for LUKS named `luks.service`:

``` ini
[Unit]
Description=Mount LUKS
Requires=gpg-agent.service
After=gpg-agent.service

[Service]
Type=oneshot
EnvironmentFile={gpgagent}
ExecStart=/path/to/luks.sh
RemainAfterExit=yes

[Install]
WantedBy=default.target
```


### Mount LUKS as a requirement for X

This section is optional. Some of important files for the boot of my X session are on the LUKS partition so I need to mount it before X starts.

I don't use any login manager (_like gdm or lightdm_) and I start X after the tty login. To make sure everything is set up, I do it via another unit file named `xsession.service`:

``` ini {hl_lines=["3-4"]}
[Unit]
Description=XSession Service
After=luks.service
Requires=gpg-agent.service luks.service

[Service]
ExecStart=/usr/bin/startx

[Install]
WantedBy=default.target
```

_**Note:**  I specify xsession to only start after `luks.service` and it explicitely requires `gpg-agent.service` for future use_

Now, I execute `systemctl --user start xsession.service` and it will start GPG Agent and the LUKS mount script for me (_and X, of course_).

_Enjoy it!_
