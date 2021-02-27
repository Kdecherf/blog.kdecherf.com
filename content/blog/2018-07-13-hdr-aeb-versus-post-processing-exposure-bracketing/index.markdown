---
title: "HDR: AEB versus post-processing exposure bracketing"
date: 2018-07-13T18:33:53+02:00
tags:
- Photography
---

HDR, or High-Dynamic-Range is a technique to improve dynamic range of a
photograph thus enhancing tricky scenes like direct sunlight. As I'm not the
best person to talk in depth about that, I'll let you check the corresponding
[Wikipedia article][1] and [some examples on Flickr][2] for more information.
One method to achieve this technique is to take several photographs of a scene
with different exposures, usually one normal, one underexposed and one
overexposed shots.

Modern DSLR have a mode to make this adjustement pretty straightforward: enter
the Auto-Exposure Bracketing mode, a.k.a. AEB. AEB lets you select three
different EV stops and will handle the variation on each shot. Shoot three
successive shots to have a complete serie matching your AEB settings. Engage the
High-Speed Shooting and you'll have AEB-enabled shots in no time[^1].

After shooting, you have two options for making a HDR photo:

* Using the HDR processor embedded on your device, if available
* Using a post-procesing software like Photomatix Pro or Photoshop

I do not recommend the first option as the HDR will take time and will basically
kill your battery. Also for Lightroom users: HDR fusion mode is
available since LR 6, _hourah_!

Now, why this post? If you already done some HDR, you may have seen artifacts on
resulting shots, consequence of the inability to fusion your shots evenly
(_because of waves, moving people, leaves, …_). It can be really frustrating.

While post-processing some shots from a night session in Paris this week, one of
the HDR had too visible artifacts. I wondered what would give a HDR fusion on
three shots of the same RAW file with three different exposures. Here we are.

I will try this technique on four shots took with a Canon EOS 60D and a Canon
PowerShot G7 X Mark II.

### Shot 1: Paris sunset using Canon EOS 60D

Here is the original shot, followed by two AEB shots at -3 EV and +3 EV:

![](grp1_original.jpg)

![](grp1_aeb_under.jpg)
![](grp1_aeb_over.jpg)

Now, here is the original shot with automatic tune:
![](grp1_original_autotune.jpg)

And the HDR automatic tune using AEB shots:
![](grp1_aeb_hdr.jpg)

You may see that dark areas are more visible in the HDR shot.

Let's do some magic with only the original shot. Make two virtual copies with
respectively -3 EV and +3 EV. It should give that:
![](grp1_raw_under.jpg)
![](grp1_raw_over.jpg)

Here is the resulting HDR automatic tune image:
![](grp1_raw_hdr.jpg)

Put side-by-side with 1:1 crop, we see that it has a lot more noise than the AEB
HDR shot (_PPEB left, AEB right_):
![](grp1_versus_raw_aeb.png)

You can play with luminance on first and third (_respectively normal and
overexposed_) shots to reduce noise (_previous PPEB left, luminance right_):
![](grp1_versus_luminance.png)

Which gives you (_luminance left, AEB right_):
![](grp1_versus_luminance_aeb.png)

And finally here is the result of HDR autotune with post-processing exposure
bracketing:
![](grp1_raw_luminance_hdr.jpg)

Put side-by-side, a comparison between HDR autotune with AEB shots on the left
and HDR autotune with the post-processing exposure bracketing shot on the right:
![](grp1_compare.jpg)

### Shot 2: Paris sunset using Canon EOS 60D

Here is the original shot, followed by the same shot with autotune:

![](grp2_original.jpg)

![](grp2_original_autotune.jpg)

And here are the two HDR shots with autotune, AEB first:

![](grp2_aeb_hdr.jpg)

![](grp2_raw_hdr.jpg)

On this shot we can see that the sun is less detailed and dark zones are less
clear when using the post-processed RAW file.

### Shot 3: Ile d'Yeu sunset using Canon EOS 60D

Here is the original shot:

![](grp3_original.jpg)

And here are the two HDR shots with autotune, AEB first:

![](grp3_aeb_hdr.jpg)

![](grp3_raw_hdr.jpg)

Like the previous scene, the sun appears brighter and less detailed than with
the AEB shots.

### Shot 4: Ha Long Bay using Canon PowerShot G7 X Mark II

For the last scene I used a shot took with a compact device. Here is the
original shot followed by the same shot with autotune:

![](grp4_original.jpg)

![](grp4_original_autotune.jpg)

And here are the two HDR shots with autotune, AEB first:

![](grp4_aeb_hdr.jpg)

![](grp4_raw_hdr.jpg)

When creating the first HDR shot (_using AEB_) I activated a corrective setting
of Lightroom which resulted in a noticeable contrast change on the rock. This
line does not appear on the HDR using post-processed RAW file.

Overall, using post-processing exposure bracketing on a RAW file seems to
provide good results close to HDR from AEB shots. Unless you have bright light
sources on the scene (_like the sun_). Also it's very likely that you'd have to
reduce noise with luminance. Apart from that it can be a solid alternative to
AEB shots when the resulting HDR of the latter generates artifacts.

_Enjoy!_

[^1]: You still depend on the aperture time which may vary between the
shots to handle the requested EV stop.

[1]: https://en.wikipedia.org/wiki/High-dynamic-range_imaging
[2]: https://www.flickr.com/search/?text=hdr
