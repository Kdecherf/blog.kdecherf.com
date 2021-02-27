---
title: "DNSWatch.in : vérifiez les serveurs DNS des FAI"
date: 2010-12-29T12:32:04+01:00
slug: dnswatch-in-verifiez-les-serveurs-dns-des-fai
tags:
- dns
- Projects
---

<div class="alert-warn">
   <strong>UPDATE 2018/02/11:</strong> le projet a été abandonné.
   Remplacement des liens vers archive.org.
</div>

Il y a quelques semaines j'avais eu la mauvaise expérience (et vous aussi, au moins une fois) d'avoir une propagation DNS lente en changeant un enregistrement : certains FAI ne distribuaient pas la bonne réponse. J'avais eu alors l'envie de savoir QUI ne répondait pas correctement, à n'importe quel moment. Malheureusement le boulot m'a occupé jusqu'à perdre de vue ce petit besoin ... jusqu'à lundi.

Etant obligé de changer de serveur, je suis retombé sur la même problématique d'avoir certains FAI ne répondant pas correctement aux requêtes DNS pour un de mes domaines. Ayant un peu de temps libre j'ai décidé de le coder ... Naquit [DNSWatch.in](https://web.archive.org/web/20110103033347/http://dnswatch.in:80/){: .archive} en 24 heures chrono.

Le concept ? Pouvoir tester un enregistrement DNS chez tous les FAI (mondiaux + providers DNS alternatifs).

L'outil se présente sous la forme d'un formulaire où vous indiquez l'enregistrement à tester et son type. Vous pouvez également restreindre la vérification à une partie du globe.

![Screenshot]({attach}Screenshot-92-11.png)
{: .image}

Une fois le test lancé, un tableau avec la liste des providers interrogés s'affiche.

Exemple concret : img.dnswatch.in que je viens de créer.

![Screenshot]({attach}Screenshot-91-2.png)
{: .image}

Orange, Nerim et Belgacom ne répondent pas car ils bloquent l'accès à leurs serveurs depuis l'extérieur (voir ci-dessous). On voit bien que Free a du mal à propager le nouvel enregistrement contrairement aux autres, déjà à jour.

### Reporteurs

Certains FAI refusent les requêtes DNS venant de l'extérieur (exemple : Orange, Nerim, ...). Pour cette raison, j'en appelle aux volontaires qui ont une machine qui tourne derrière l'un des FAI concernés et qui souhaitent participer au projet. Un script (reporting proxy) sera fait sous peu et disponible sur GitHub. Les requêtes entre le master et les proxies seront signées. Plus d'infos [ici](https://web.archive.org/web/20110104113406/http://dnswatch.in:80/info.html){: .archive} (_et à venir_).

De la même manière, si vous souhaitez rajouter des serveurs DNS, des providers alternatifs ou autre ... N'hésitez pas à envoyer un email à l'adresse indiquée.

Et comme je suis un gentil, le code source de cet outil sera prochainement libéré et disponible sur GitHub aussi ;-)

Ah, j'oubliais : le site utilise quelques petites fonctionnalités HTML 5.
