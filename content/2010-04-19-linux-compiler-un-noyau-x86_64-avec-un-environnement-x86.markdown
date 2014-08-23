Date: 2010-04-19 21:53:05
Title: Linux : Compiler un noyau x86_64 avec un environnement x86
Category: Tips

Cela fait un long moment que je n'ai rien posté, je reviens donc avec une petite astuce qui, je l'espère, pourra vous être utile.

Il y a peu j'ai récupéré mon fixe qui détient une Gentoo depuis quelques années, elle n'a pas été mise à jour depuis Janvier 2009. Je m'engage donc dans la mise à jour de certains paquets sans vraiment chercher à comprendre. Quelques jours plus tard, je reboote la machine et c'est le drame : udev n'est pas supporté par mon vieux kernel (_2.6.25_).

Solution de secours, je sors mon arme ultime : une Backtrack 4. C'est en tentant de faire mon chroot que je remarque l'échec final : les deux systèmes n'ont pas la même architecture.

Pas de problème, je vais compiler le noyau sans chroot ... Mais heu ... Comment compiler un noyau x86\_64 sur un environnement x86 ? La Cross-Compilation nous vient de suite à l'esprit. Cependant, devoir recompiler _binutils, gcc_ et autres avec les toolchains amd64 ne me donne pas envie ... C'est alors que je découvre le mode **multilib** de **GCC** : on peut spécifier de compiler en 32 ou 64 bits avec le flag **-m** (_-m32 ou -m64_).

A cela nous combinons l'inverse de l'astuce qui se trouve [ici](http://tinkering-is-fun.blogspot.com/2009/12/compiling-linux-kernel-for-x86-on-x8664.html) et on obtient ceci :

``` bash
apt-get install gcc-multilib
mkdir ~/bin
(echo '#!/bin/sh'; echo 'exec gcc -m64 "$@"';) > ~/bin/x86_64-linux-gnu-gcc
chmod +x ~/bin/x86_64-linux-gnu-gcc
for i in ar ld nm objcopy strip; do ln -s `which $i` ~/bin/x86_64-linux-gnu-$i
done
```

Et maintenant, vous pouvez compiler tranquillement votre noyau x86\_64 :

**UPDATE : **Pensez à ajouter ~/bin à votre variable $PATH !

``` bash
usr/src/linux $ make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- menuconfig
usr/src/linux $ make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu-
```

Une fois le travail effectué, vous pouvez bouger `x86/boot/bzImage` vers `/boot`. Enjoy it !
