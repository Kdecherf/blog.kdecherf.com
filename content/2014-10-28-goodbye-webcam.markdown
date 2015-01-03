Title: Goodbye Webcam
Date: 2014-10-30 15:03
Category: Tips

I have suspected my webcam to have an electrical default for a while. As a result I used to have plenty of USB connect/disconnect/error events in the kernel journal like the following lines:

```
kernel: usb 1-1.2: new full-speed USB device number 123 using ehci-pci
kernel: usb 1-1.2: new high-speed USB device number 126 using ehci-pci
kernel: usb 1-1.2: new high-speed USB device number 127 using ehci-pci
kernel: usb 1-1.2: new high-speed USB device number 5 using ehci-pci
kernel: usb 1-1.2: new high-speed USB device number 6 using ehci-pci
kernel: usb 1-1.2: new high-speed USB device number 7 using ehci-pci
kernel: usb 1-1.2: new high-speed USB device number 8 using ehci-pci
[...]
mtp-probe[8351]: checking bus 1, device 7: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2"
mtp-probe[8351]: bus: 1, device: 7 was not an MTP device
[...]
kernel: usb 1-1.2: USB disconnect, device number 88
kernel: usb 1-1.2: new high-speed USB device number 89 using ehci-pci
kernel: usb 1-1.2: device not accepting address 89, error -71
kernel: usb 1-1.2: new high-speed USB device number 90 using ehci-pci
kernel: usb 1-1.2: device descriptor read/64, error -71
kernel: usb 1-1.2: device descriptor read/64, error -71
```

It is quite annoying, right?

Well, how can I virtually cut off this usb device without physically altering my laptop?  
There is a way to unbind a whole hub by echoing its pci address to `/sys/bus/pci/drivers/ehci-pci/unbind` (_`ehci-pci` may vary depending on the driver used by your system to manage the usb hubs_). The pci address can be found in the logs of `mtp-probe` which says in my case that the hub has the address `0000:00:1a.0`.

With this method, you will lose all devices connected to the same hub (_Bus 1_). So, what will I lose?

``` bash
sakura ~ # lsusb -s 1:
Bus 001 Device 004: ID 058f:a014 Alcor Micro Corp. Asus Integrated Webcam
Bus 001 Device 003: ID 13d3:3304 IMC Networks Asus Integrated Bluetooth module [AR3011]
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

Oh god, I will lose my bluetooth module... Oh wait, I don't use it. NUKE ALL THE HUB \o/

``` bash
echo "0000:00:1a.0" > /sys/bus/pci/drivers/ehci-pci/unbind
```

The kernel confirms that the hub has been deregistered:

```
kernel: ehci-pci 0000:00:1a.0: remove, state 1
kernel: usb usb1: USB disconnect, device number 1
kernel: usb 1-1: USB disconnect, device number 2
kernel: usb 1-1.1: USB disconnect, device number 3
kernel: usb 1-1.2: USB disconnect, device number 4
kernel: ehci-pci 0000:00:1a.0: USB bus 1 deregistered
```

And a `lsusb -s 1:` will return an empty response, that's good. The webcam is now disabled.

Unfortunately this setting does not persist after a reboot. What can I do?

Let make a little udev rule to disable the hub on the first add/remove event. Create a file, say, `/etc/udev/rules.d/01-disable-webcam.rules` with the following content:

```
ACTION=="add|remove",DEVPATH=="/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2",RUN="/usr/local/bin/disable-webcam.sh"
```

The **ACTION** part tells to match all `add` and `remove` events, and the **DEVPATH** specifies the device path. Finally we override the **RUN** variable with the path of a tiny script:

``` bash
#!/bin/bash

echo "0000:00:1a.0" > /sys/bus/pci/drivers/ehci-pci/unbind
```

With this rule, you should now see something like the following stack at boot:

```
mtp-probe[2348]: checking bus 1, device 4: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2"
mtp-probe[2348]: bus: 1, device: 4 was not an MTP device
kernel: ehci-pci 0000:00:1a.0: remove, state 1
kernel: usb usb1: USB disconnect, device number 1
kernel: usb 1-1: USB disconnect, device number 2
kernel: usb 1-1.1: USB disconnect, device number 3
kernel: usb 1-1.2: USB disconnect, device number 4
kernel: ehci-pci 0000:00:1a.0: USB bus 1 deregistered
```

_Enjoy!_
