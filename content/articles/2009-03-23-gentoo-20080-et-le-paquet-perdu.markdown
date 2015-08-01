Date: 2009-03-23 12:14:53
Title: Gentoo 2008.0 et le paquet perdu
Category: Tips
Tags: gentoo

Les amoureux de la distribution Gentoo Linux vous le diront, chaque release a eu sa part de bug à l'installation. Sur la 2008.0 lors de la première mise à jour complète du système, il y avait 2 paquets qui se bloquaient pour des versions interdites.

Pour en sortir, il fallait faire :

``` shell-session
emerge -f e2fsprogs e2fsprogs-libs
emerge --unmerge e2fsprogs ss com_err
emerge -va e2fsprogs e2fsprogs-libs
```

Jusque là, cela reste une manipulation avec avertissement mais banale. Ceci étant, en cas de plantage le système peut être fortement endommagé.

J'ai une petite pensée pour une personne qui a eu ce problème : l'ordinateur s'est éteint durant l'exécution du dernier emerge ce qui a causé la perte de commandes comme `fsck`. Conséquence : la distribution refuse de booter.

Heureusement, c'est fini ! Désormais quand vous installez une Gentoo, commencez par mettre à jour `portage` puis ensuite faites votre classique `emerge -DuvaN world`

``` shell-session
emerge -va portage
emerge -DuvaN world
```

Et là surprise ! Il n'y a plus d'erreur mais 2 nouvelles lignes et Portage met à jour tout seul les paquets qui bloquaient :)
