---
date: '2010-11-07 18:56:38'
layout: post
title: 'MySQL & PHP : Scénarios de migration'
categories: [Articles]
comments: true
---

Il n'y a rien de plus frustrant que de se retrouver coincé en tentant de migrer une base de données en utilisant des techniques non adaptées au nouvel hébergement. Voici un petit billet qui vous liste les différents scénarios possibles de migration d'une base de données MySQL (_en partant du principe que le site est en PHP_).

### J'ai une petite base de données (&lt; 2 Mo)

#### Je dispose de PHPMyAdmin

PMA est l'outil le plus répandu de gestion de bases de données MySQL, par conséquent c'est le plus utilisé pour importer une base. Cet outil est limité par les directives du serveur web concernant la taille maximale des fichiers pouvant être envoyés par un internautes et le délai maximum d’exécution d'un script. Par conséquent, cette technique ne convient qu'aux petites bases (_la limite se situe généralement entre 2 et 8 Mo_).

#### ... ou pas

Si vous n'avez pas PMA sous la main, vous pouvez toujours vous rabattre sur des outils tels que [BigDump](http://www.ozerov.de/bigdump.php). Cependant cet outil peut également être bloqué par le délai maximum d'exécution autorisé par le serveur, de même que certaines instructions MySQL ne sont pas lues. Si vous êtes intéressés par cet outil, vous trouverez un petit tuto [ici](http://drupal.org/node/43024).

### J'ai une grosse base de données

#### Et un accès SSH !

Si vous avez un accès SSH, ne cherchez pas plus loin. Envoyez votre fichier SQL à la racine de votre site et utilisez la commande _mysql_ pour importer la base.
     
``` bash
mysql -u dbuser -p dbname < monfichier.sql
```

_Si vous avez un fichier compressé, pensez à le décompresser avant d'exécuter la commande._

#### ... ou pas

Une grosse base de données à importer mais pas d'accès SSH ? Pas de panique, il nous reste une solution : l'exécution de la commande _mysql_ depuis un script PHP. De la même manière que si vous aviez un accès SSH, envoyez votre fichier SQL à la racine de votre site puis créez un fichier PHP qui contient :

``` php
<?php
passthru("nohup mysql -u dbuser -pmonmotdepasse dbname < monfichier.sql");
?>
```

Il est important ici de préciser le mot de passe de connexion dans la commande.

**Aller plus loin : MySQLDumper**

[MySQLDumper](http://www.mysqldumper.net/) est un outil écrit en PHP et Perl, il permet d'importer/exporter de très grosses bases en prenant en compte les limitations de durée d'exécution des scripts. Cette solution nécessite cependant d'avoir un accès suffisant chez l'hébergeur pour l'installer et l'utiliser.

**Aucune solution ne fonctionne**

Si aucune solution citée ici ne fonctionne, je pense que vous avez mal choisi votre hébergeur :)
