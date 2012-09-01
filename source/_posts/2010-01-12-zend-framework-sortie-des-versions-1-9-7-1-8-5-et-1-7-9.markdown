---
date: '2010-01-12 22:05:16'
layout: post
title: 'Zend Framework : Sortie des versions 1.9.7, 1.8.5 et 1.7.9'
comments: true
---

L'équipe en charge du développement du célèbre framework PHP vient d'annoncer la disponibilité d'une mise à jour pour ses trois branches **1.9**, **1.8** et **1.7**.

{% img center /images/2009/05/zend-framework.png 'Zend Framework' 'Zend Framework' %}

Estampillées **1.9.7**, **1.8.5** et **1.7.9**, ces mises à jour corrigent **6 failles de sécurité** découvertes il y a quelques semaines ainsi que près de **40 bugs**. Vous retrouverez les changelogs [_ici_](http://framework.zend.com/changelog/1.9.7), [_ici_](http://framework.zend.com/changelog/1.8.5) et [_là_](http://framework.zend.com/changelog/1.7.9).

Cinq failles de sécurité, principalement des injections XSS et une injection MIME-type, concernent les modules [Zend\_Json](http://framework.zend.com/security/advisory/ZF2010-06), [Zend\_Service\_ReCaptcha\_MailHide](http://framework.zend.com/security/advisory/ZF2010-05), [Zend\_File\_Transfer](http://framework.zend.com/security/advisory/ZF2010-04), [Zend\_Filter\_StripTags](http://framework.zend.com/security/advisory/ZF2010-03) et [Zend\_Dojo\_View\_Helper\_Editor](http://framework.zend.com/security/advisory/ZF2010-02). La sixième faille concerne une [inconsistance](http://framework.zend.com/security/advisory/ZF2010-01) au niveau de l'encodage utilisé dans de nombreux modules.

La compagnie ajoute que la version 1.9.7 est la dernière _release_ de la branche 1.9 avant la sortie de la version **1.10**. Version 1.10 qui, actuellement en [alpha](http://devzone.zend.com/article/11503-Zend-Framework-1.10.0alpha1-Released), devrait sortir en beta cette semaine puis en version finale un peu plus tard dans le mois.

_Source : [Zend Developer Zone](http://devzone.zend.com/article/11622-Zend-Framework-1.9.7-1.8.5-and-1.7.9-Released)_
