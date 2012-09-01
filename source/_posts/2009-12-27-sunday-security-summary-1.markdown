---
date: '2009-12-27 13:12:11'
layout: post
title: 'Sunday Security Summary #1'
comments: true
---

Premier épisode d'une série sans fin, le **Sunday Security Summary** (3S) est le rendez-vous de la semaine pour faire un petit point sur la sécurité. _Bien sûr, ce n'est qu'une liste non exhaustive. _Dans ce rapport, aujourd'hui : noyau Linux, PHP, Zend Fx, Drupal et APC.

{% img center /images/2009/12/3S.png '3S' '3S' %}

**Failles système**
	
  * **[CVE-2009-4406](http://ow.ly/PlvP)** : Injection XSS dans le formulaire de login sur l'**APC Switched Rack PDU AP7932 B2** avec _rpdu 3.3.3_ ou _3.7.0_ sur _AOS 3.3.4_.
  * **[CVE-2009-4410](http://ow.ly/PWPo)** : Deni de service (_Kernel panic_) via le module FUSE sur les noyaux **Linux 2.6.29-rc1** à **2.6.30.9**.

**Failles Web**
	
  * **[CVE-2009-4369](http://ow.ly/OvTM) **: Injection XSS dans le module Contact pour **Drupal 5.x** avant _5.21_ et **6.x** avant _6.15_.
  * **[CVE-2009-4370](http://ow.ly/OvRY)** : Injection XSS dans le module Menu pour **Drupal 6.x** avant _6.15_.
  * **[CVE-2009-4371](http://ow.ly/OvSU)** : Injection XSS dans le module Locale pour **Drupal 6.14**.
  * **[CVE-2009-4142](http://ow.ly/OvQ2)** : Faille de sécurité via les Sessions sur toutes les versions de **PHP** inférieures à _5.2.12_.
  * **[CVE-2009-4418](http://ow.ly/PWQ4)** : Deni de service via une sérialisation de variable dans **PHP 5**.
  * **[CVE-2009-4417](http://ow.ly/PWQK)** : Faille de sécurité permettant d'envoyer des emails via le *module Zend_Log_Writer_Mail* dans **Zend Framework 1.9** et versions précédentes.

Vous pouvez retrouver, _tous les jours ou presque_, ces annonces sur la [NVD](http://web.nvd.nist.gov/) ou via le hash-tag Twitter [#NVD](http://search.twitter.com/search?q=%23NVD).

A l'année prochaine ! ;-)
