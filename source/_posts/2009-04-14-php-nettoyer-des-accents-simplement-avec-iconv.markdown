---
date: '2009-04-14 01:58:50'
layout: post
title: 'PHP : Nettoyer des accents simplement avec Iconv'
categories: [Tips]
tags: [php]
comments: true
---

Après un ralentissement de mon activité, je reviens avec une nouvelle astuce PHP. Cette fois-ci, je m'attarde sur une méthode très puissante pour nettoyer des accents avec **Iconv**.

En quoi cela peut-être utile de nettoyer les accents d'une phrase ? Tout simplement si vous souhaitez faire des liens hypertextes, illustration.

Je prends un article récent de PC Inpact : "Dessin : la loi Hadopi pourrait être représentée très bientôt"

On peut très bien l'encoder pour le passer dans une URL avec _rawurlencode()_ ce qui donne :

```
Dessin%20%3A%20la%20loi%20Hadopi%20pourrait%20%C3%AAtre%20repr%C3%A9sent%C3%A9e%20tr%C3%A8s%20bient%C3%B4t
```

Vous avouez, _sans mal_, que ce n'est pas très beau ! Alors on va utiliser iconv pour nettoyer les accents et non les convertir, exemple : _é_ et _è_ deviennent _e_.

``` php
<?php
setlocale(LC_ALL,'fr_FR.UTF-8');
iconv("UTF-8","ASCII//TRANSLIT","Dessin : la loi Hadopi pourrait être représentée très bientôt");
?>
```

Ce qui donne le résultat suivant :

```
Dessin : la loi Hadopi pourrait etre representee tres bientot
```

**Explication du code**

Concrètement, nous partons du titre au format UTF-8 et nous souhaitons le convertir au format ASCII car il ne comporte pas d'accents (si vous avez un doute, je vous invite à réviser vos jeux de caractères ;-) ).

Le _setlocale()_ est **obligatoire**, par défaut PHP ne va pas savoir quel jeu utiliser, au mieux il va utiliser POSIX. Je vous conseille le jeu _fr_FR.UTF-8_ voire _en_US.UTF-8_ (oui, je ne parle que de jeux UTF-8 ici).

Dernier point, _//TRANSLIT_ est une option qui indique à PHP de tenter de convertir les caractères dits _illégaux_ dans le format de destination. C'est cette option qui transforme les accents en leurs caractères standards. Sans cette option, PHP stoppe l'execution de la fonction au premier caractère illégal trouvé. Vous avez également l'option _//IGNORE_ qui va simplement ignorer les caractères illégaux.

Et voilà, une astuce de plus ! En esperant que cela vous serve ;-)
