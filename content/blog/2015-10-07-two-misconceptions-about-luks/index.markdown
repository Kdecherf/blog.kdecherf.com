---
title: "Two misconceptions about LUKS"
date: 2015-10-07T15:43:00+02:00
tags:
- luks
---

Few weeks ago I had a discussion about LUKS (_Linux Unified Key Setup_) and the purpose of using a (openssl|gpg|whatever)-encrypted random passphrase. I heard two things which I want to comment:

> "I encrypt a random passphrase using OpenSSL/GPG/whatever to avoid disk re-encryption if I want to change it"

> "I encrypt a random passphrase to have it separated from the device"

### Key management on LUKS

The first statement is incorrect. As described in the [LUKS On-Disk Format Specification (PDF)](https://gitlab.com/cryptsetup/cryptsetup/-/wikis/LUKS-standard/on-disk-format.pdf), LUKS does not use your passphrase to encrypt your device but uses it to encrypt a randomly generated master key and stores it in a key slot.

LUKS can manage up to 8 key slot and each active key slot stores an encrypted copy of the master key using its password. In fact when you type your password to unlock a device, `cryptsetup` checks it against all active key slots to find the correct one and decrypts the master key.

Thus you can change the passphrase of your LUKS container without actually re-encrypting the data. On the other hand a passphrase change requires you to unlock the device first, add your new passphrase on a new key slot and remove the old one; which can lead to data loss if it is not done correctly.

### Header separation

The second statement could be handled using another approach: header separation.

By default the header of a LUKS devices —which keeps key slots, salt, checksums and other metadata— is stored at the beginning of the device itself. `cryptsetup` can use a separated header using the argument `--header` when unlocking a LUKS device.

This approach has a significant advantage compared to the separated encrypted passphrase: if the header is detached, the device will appear as storing a bunch of random bytes from the start to the end.

Put in other words, without the header **there is no way to decrypt the data**; whereas with the header on the device and the key as a separate file you know at least some of the metadata used to encrypt the data.

### So what?

If you are concerned about the separation of your device and the stuff which decrypts it you should detach the header instead of just encrypting your passphrase.

Please note that none of these approaches really protects you in case of header leakage.

_Enjoy!_
