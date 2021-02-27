---
title: "FFmpeg: converting M4A files to MP3 with the same bitrate"
date: 2012-01-14T19:54:23+01:00
tags:
- ffmpeg
---

Hello World,

Today I show you a (really) tiny tip to convert M4A files to MP3 keeping bitrate with FFmpeg.

By using the command `ffmpeg -i thefile` we obtain data about all streams of the file (codec, bitrate, ...), like this:

```
$ ffmpeg -i test.m4a
[...]
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'test.m4a':
  Metadata:
    major_brand     : M4A 
    minor_version   : 1
    compatible_brands: M4A mp42isom
    creation_time   : 2012-01-06 13:08:47
    composer        : Tiësto
    title           : clublife_episode249
    artist          : Tiësto
    album           : Tiësto
    encoder         : GarageBand 6.0.4
  Duration: 00:59:04.87, start: 0.000000, bitrate: 324 kb/s
    Chapter #0.0: start 0.000000, end 31.000000
    Metadata:
      title           : Begin
    [...]
    Stream #0.0(eng): Subtitle: tx3g / 0x67337874, 0 kb/s
    Metadata:
      creation_time   : 2012-01-06 13:08:47
    Stream #0.1(eng): Subtitle: tx3g / 0x67337874
    Metadata:
      creation_time   : 2012-01-06 13:08:47
    Stream #0.2(eng): Audio: aac, 44100 Hz, stereo, s16, 319 kb/s
    Metadata:
      creation_time   : 2012-01-06 13:08:47
    Stream #0.3(eng): Video: mjpeg, yuvj444p, 300x300 [PAR 72:72 DAR 1:1], 2 kb/s, 0k fps, 600 tbr, 600 tbn, 600 tbc
    Metadata:
      creation_time   : 2012-01-06 13:08:47
```

Well, the line we need to use for the bitrate is `Stream #0.2(eng): Audio: aac, 44100 Hz, stereo, s16, 319 kb/s`. Now we can play with grep and awk to extract _319_ (_according to the example line_):

``` bash
$ ffmpeg -i test.m4a 2>&1 | grep Audio | awk -F', ' '{print $5}' | cut -d' ' -f1
319
```

This output will be used for the `-ab` argument:

``` bash
ffmpeg -i test.m4a -ab `ffmpeg -i test.m4a 2>&1 | grep Audio | awk -F', ' '{print $5}' | cut -d' ' -f1`k test.mp3
```

Finally, we verify the new file:

```
$ ffmpeg -i test.mp3
[...]
Input #0, mp3, from 'test.mp3':
  Metadata:
    major_brand     : M4A 
    minor_version   : 1
    compatible_brands: M4A mp42isom
    creation_time   : 2012-01-06 13:08:47
    composer        : Tiësto
    title           : clublife_episode249
    artist          : Tiësto
    album           : Tiësto
    encoder         : Lavf53.2.0
  Duration: 00:59:04.93, start: 0.000000, bitrate: 320 kb/s
    Stream #0.0: Audio: mp3, 44100 Hz, stereo, s16, 320 kb/s
```

Enjoy it !
