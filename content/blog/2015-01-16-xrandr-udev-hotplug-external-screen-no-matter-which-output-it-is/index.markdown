---
title: "xrandr+udev: hotplug an external screen no matter which output it is"
date: 2015-01-16T14:13:00+01:00
slug: xrandrudev-hotplug-an-external-screen-no-matter-which-output-it-is
tags:
- xrandr
- udev
- linux
---

Hey world this is my first post of the year, I hope I will break my record of 2 posts for the last year.

Going back to the first days of my current laptop (_it is still alive!_), I found a [post](http://ruedigergad.com/2012/01/28/hotplug-an-external-screen-to-your-laptop-on-linux/) to automatically activate an external screen when plugging it.

This script works only for a fixed output, in this case the output `VGA1`.

As I use my VGA or my HDMI port depending on what I find on my desk, I want the script to recognize the relevant output when I plug an external screen.

Let's check the output of `xrandr --query` in each case.

When an external screen is connected and configured (_here using the HDMI port_), `xrandr` says _connected_ and shows the active mode:
``` plain
HDMI1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 598mm x 336mm
```

When the external screen is connected but not configured (_it has just been plugged_), `xrandr` does not show any active mode:
``` plain
HDMI1 connected (normal left inverted right x axis y axis)
```

In the last case we've just unplugged the screen, `xrandr` still shows the configured mode for the output:
``` plain
HDMI1 disconnected 1920x1080+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
```

Using the last two statements, we can update the script to recognize the modified output and take action accordingly:

``` bash
#!/bin/bash

set -o pipefail

export DISPLAY=:0.0
export XAUTHORITY=/home/foobar/.Xauthority

function connect(){
   logger -t udev "$1 connected"
   xrandr --output $1 --auto --right-of LVDS1
}

function disconnect(){
   logger -t udev "$1 disconnected"
   xrandr --output $1 --off
}

query=$(xrandr --query)
connected_output=$(echo "${query}" | egrep "^[A-Z0-1]+ connected \(" | awk -F' ' '{print $1}')
if [[ $? == 0 ]]; then
   connect $connected_output
else
   disconnected_output=$(echo "${query}" | egrep "^[A-Z0-1]+ disconnected [0-9]+x[0-9]+\+[0-9]+\+[0-9]+" | awk -F' ' '{print $1}')
   if [[ $? == 0 ]]; then
      disconnect $disconnected_output
   fi
fi
```

Notes:

* `set -o pipefail` prevents a piped command to squeeze the return code of the previous commands (_if it's a non-zero return code_). It's useful when we use `awk` after the `egrep` and want to use the return code of the latter.
* I've replaced `echo "$1 connected"` with `logger` to log relevant messages using the syslog/journal socket of my system.

_Enjoy!_
