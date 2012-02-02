---
date: '2009-05-04 22:58:18'
layout: post
title: Koobface ou comment casser des CAPTCHA ... à la main (d'oeuvre)
categories: [Unclassified]
comments: true
---

Ne dit-on pas que les cybercriminels débordent de créativité ? On les voit encore une fois à l'œuvre d'une manière originale.

{% img center /images/2009/05/fig3_koobface_tb.jpg 'koobface' 'koobface' %}

La nouvelle campagne de spam **Koobface** reprend une interface copiée de YouTube pour envoyer son ver qui est pour le moins particulier.

Pour situer l'origine de l'infection d'un poste, un internaute reçoit le lien d'une vidéo soit-disant sur YouTube et se rend sur le site. Ici le site détourné affiche un message comme quoi il doit mettre à jour Flash Player. Le fichier _setup.exe_ ainsi envoyé est en fait un ver.

Mais que fait ce ver ? Une fois exécute, il va indiquer à l'utilisateur que l'ordinateur va redémarrer passé un délai de 2 minutes 30. L'utilisateur, pour annuler cette action, doit lire et valider un captcha (ces images anti-robots).

L'envers du décor ? Ces images captcha proviennent en réalité de sites divers auxquels des robots tentent d'accéder, il est vrai qu'il n'y a rien de mieux que l'interaction humaine pour valider un captcha. Ainsi on connaissait des botnets ambulants pour des attaques groupés du type _DDoS_, maintenant nous avons des " botnets" (indirects puisque nécessitant une intervention humaine) pour casser des captchas.

_Source : [Trend Micro](http://blog.trendmicro.com/koobface-tries-captcha-breaking/)_
