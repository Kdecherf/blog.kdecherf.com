---
date: '2009-10-27 17:00:44'
layout: post
slug: fakeav-sait-se-faire-passer-pour-un-vrai
status: publish
title: FakeAV sait se faire passer pour un vrai
wordpress_id: '1123'
categories:
- Unclassified
---

FakeAV, ce malware qui se fait passer pour un anti-virus en vous faisant croire que votre système est infecté sait également feinter son apparition sur un réseau ou sur le système.







![AVPro2010_20091023gif](http://blog.kdecherf.com/wp-content/uploads/2009/10/AVPro2010_20091023gif.gif)







En effet, _David Sancho_, chercheur chez Trend Micro, a fait une petite découverte intéressante. FakeAV, pour limiter sa visibilité, télécharge sur le poste infecté des fichiers de signatures de ClamAV, antivirus open-source pour plateforme UNIX. Après quelques essais en testant différents fichiers de signatures (des vrais fichiers ClamAV et les fichiers de signatures FakeAV) il s'avère que les fichiers de signatures ClamAV ne sont jamais utilisés. Ils sont donc là juste pour faire croire à la mise à jour d'un vrai anti-virus. Ils sont ingénieux ces salauds (_ou pas_) :)







_Source : _[_Trend Micro Malware Blog_](http://blog.trendmicro.com/fakeav-goes-open-source%E2%80%A6-or-not/)



