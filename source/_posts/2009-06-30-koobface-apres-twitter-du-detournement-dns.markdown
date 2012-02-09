---
date: '2009-06-30 01:53:06'
layout: post
title: 'Koobface : Après Twitter, du détournement DNS'
categories: [Unclassified]
comments: true
---

Après la [découverte](/2009/06/26/koobface-se-met-a-twitter/) d'un composant pour se propager via Twitter, Koobface dispose désormais d'un composant pour détourner les serveurs DNS.

Ce composant, apparement inactif pour l'heure, change le serveur DNS primaire du poste infecté pour renvoyer les internautes vers des sites phishing.  
La clé de registre vérolée est *HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{Device ID}*. Si jamais vous y trouvez **213.174.139.72**, il est conseillé de le supprimer et de faire un nettoyage de l'ordinateur.

_Source : [Trend Micro Malware Blog](http://blog.trendmicro.com/new-koobface-component-a-dns-changer/)_
