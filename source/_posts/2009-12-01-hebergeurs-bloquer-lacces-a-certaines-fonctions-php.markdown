---
date: '2009-12-01 16:35:03'
layout: post
slug: hebergeurs-bloquer-lacces-a-certaines-fonctions-php
status: publish
title: 'Hébergeurs : bloquer l''accès à certaines fonctions PHP'
wordpress_id: '1129'
categories:
- Tips
tags:
- php
---

Si _safe_mode_ est efficace, il n'en est pas moins trop efficace au point d'empêcher le bon fonctionnement d'un certain nombre de sites ...




Si vous souhaitez bloquer seulement quelques fonctions (_safe_mode_ ou pas), vous avez à votre disposition la directive _[disable_functions](http://www.php.net/manual/en/ini.core.php#ini.disable-functions)_ à mettre dans le fichier **php.ini**.


[text]disable_functions=mail,fopen,exec[/text]


A noter que cette astuce est très efficace avec des solutions comme SuPHP permettant d'avoir un php.ini séparé par site.



