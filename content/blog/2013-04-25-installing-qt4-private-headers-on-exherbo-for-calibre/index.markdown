---
title: "Installing Qt4 private headers on Exherbo for Calibre"
date: 2013-04-25T16:21:00+02:00
tags:
- exherbo
---

Hey folks, another tip for another issue. The last week-end I played with Calibre to convert ePub books into PDF files (_nevermind, it was for someone else_). Calibre comes with `ebook-convert` but for some obscur reasons it uses private headers of Qt4.

Since it's a really really bad practice to use private headers (_they are not intended to be used by third-party applications_) and Exherbo's community does not like this kind of practice, `x11-libs/qt:4` does not provide its private headers.

The default source of Calibre will try to use Qt4 private headers but [will fail](https://bugs.launchpad.net/calibre/+bug/1094719). A patch was added to calibre to disable *qt_hack*, the piece of code which uses the private headers.

The idea here is to disable the patch, install Qt4 private headers and ending with the resolve of calibre.

For a quick fix, I edited the exheres of calibre in `/var/db/paludis/repositories/media/`:

``` diff
--- a/packages/app-text/calibre/calibre-0.9.27.exheres-0
+++ b/packages/app-text/calibre/calibre-0.9.27.exheres-0
@@ -6,5 +6,5 @@ require calibre
 PLATFORMS="~amd64 ~x86"
  
 # Insane upstream: https://bugs.launchpad.net/calibre/+bug/1094719
-DEFAULT_SRC_PREPARE_PATCHES+=( "${FILES}"/0001-Remove-the-qt_hack-extension-because-it-uses-private.patch )
+#DEFAULT_SRC_PREPARE_PATCHES+=( "${FILES}"/0001-Remove-the-qt_hack-extension-because-it-uses-private.patch )
```

After that, the fun part begins.
We need to install the private headers, but I don't want to install non-tracked files which will be more difficult to remove than with a simple `cave uninstall`.

First, I found the install process of private headers from the `qt4-private-headers` [package of ArchLinux](https://projects.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/qt4-private-headers) and used it in a temporary folder:

``` bash
cd /tmp
wget http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.4.tar.gz
tar -xvzf qt-everywhere-opensource-src-4.8.4.tar.gz
sourcedir=/tmp/qt-everywhere-opensource-src-4.8.4
destdir=/tmp/hack/usr
mkdir -p hack/usr/include/qt4/{QtCore,QtDeclarative,QtGui,QtScript}
mkdir -p hack/usr/src/qt4/{corelib,declarative,gui,script}
for i in QtCore QtDeclarative QtGui QtScript; do cp -r $sourcedir/include/${i}/private/ $destdir/include/qt4/${i}/ ; done
find $destdir/include/qt4/ -name *.h -exec sed -i 's|#include "../../../src/|#include "../../../src/qt4/|' {} \;
for i in corelib declarative gui script; do cp -r $sourcedir/src/${i} $destdir/src/qt4/ ; done
```

At this moment, we have all necessary files installed in a fake root (`/tmp/hack`). Now it's time to use our magical tool: `cave import`.  
This tool allows us to emulate real packages with final files, it's really useful when we want to install a weird package on our machine without pushing it to the community.

Just type: `cd /tmp/hack ; cave import shit-incoming/qt4-fucking-private-headers -x`

``` bash
$ cave show shit-incoming/qt4-fucking-private-headers
* shit-incoming/qt4-fucking-private-headers
    ::installed-unpackaged    0 {:0}
    shit-incoming/qt4-fucking-private-headers-0:0::installed-unpackaged (world)
    Description
    Installed time            Sat Apr 20 17:49:37 CEST 2013
    Source repository         unpackaged
```

Fat, isn't it? Well, now we can resolve calibre with its qt\_hack module.

When you want to remove these files, just use `cave uninstall shit-incoming/qt4-fucking-private-headers -x`

_Enjoy!_
