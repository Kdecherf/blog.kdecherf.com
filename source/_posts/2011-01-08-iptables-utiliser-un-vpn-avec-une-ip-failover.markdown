---
date: '2011-01-08 16:37:31'
layout: post
slug: iptables-utiliser-un-vpn-avec-une-ip-failover
status: publish
title: 'Iptables : Utiliser un VPN avec une IP failover'
wordpress_id: '1755'
categories:
- Tips
---

Allez, une petite astuce (_très facile mais je la donne quand même_) pour bien commencer le week-end. Considérons un serveur avec une interface réseau et plusieurs IP failover (_un serveur chez OVH par exemple_), comment pouvons-nous utiliser l'une de ces IP failover pour la sortie d'un VPN ? Avec Iptables, la table nat, la chaîne POSTROUTING et la cible SNAT :





> iptables -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to-source ipfailover





Pensez à remplacer _ipfailover_ par l'adresse IP publique à utiliser et _10.8.0.0/24_ par le réseau de votre VPN. Et bon week-end !





