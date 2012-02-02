---
date: '2009-05-15 00:03:19'
layout: post
title: 'Windows Azure : du PHP dans le Cloud !'
categories: [Unclassified]
tags: [cloud computing,php]
comments: true
---

Avec l'apparition de **Windows Azure**, plateforme de **Cloud Computing**, Microsoft souhaite offrir une grande interopérabilité en matière de langages pouvant être déployés.

{% img center /images/2009/05/windows-azure-logo_1.jpg 'windows azure' 'windows azure' %}

C'est à la [_TechEd India_](http://www.microsoft.com/india/teched2009/) que _Vijay Rajagopalan_, Architecte principal chez _Microsoft Corporation_, a annoncé la disponibilité du **SDK PHP pour Windows Azure**.

Pourquoi un SDK ? Parce que la plateforme Windows Azure se dessine en une architecture spécifique. On peut résumer cette architecture en un schéma du genre :

![drawing2](http://blog.kdecherf.com/wp-content/uploads/2009/05/drawing2.png)

Il y a donc 2 rôles importants : **Web** et **Worker**. Web s'occupe de tout ce qui est site web tandis que Worker peut être apparenté aux tâches de fond. Ces deux rôles accédent à une zone de stockage de données persistentes : Queues, Tables ou encore Blobs.

Par défaut, l'architecture est prévue pour accueillir du .NET et donc l'accès à la zone de stockage est fait en conséquence. De plus, concernant les standards implémentés on retrouve du **SOAP**, **REST** et du **XML**.

C'est donc dans un soucis d'intéropérabilité que le SDK PHP est désormais disponible. Ce SDK permet d'accèder aux 3 structures de données stockées ainsi que l'utilisation du standard REST. On retrouvera également le portage de fonctions et de méthodes nécessaires pour du debugging, du logging ou encore de l'authentification de type **AuthN/AuthZ**.

**[SDK PHP pour Azure](http://phpazure.codeplex.com/)** (_via CodePlex_)

D'autres langages ont également leur SDK : [Java](http://www.jdotnetservices.com/) et [Ruby](http://www.dotnetservicesruby.com/).

Parmi les autres annonces, on note également la sortie d'un framework d'implémentation des contrôles Silverlight pour PHP ! Ca se passe [ici](http://silverlightphp.codeplex.com/).

_Source : [Interoperability @ Microsoft](http://blogs.msdn.com/interoperability/archive/2009/05/13/announcing-php-sdk-for-windows-azure-and-much-more.aspx)_
