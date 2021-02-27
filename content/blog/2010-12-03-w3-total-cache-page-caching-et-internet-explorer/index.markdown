---
title: "W3 Total Cache : Page caching et Internet Explorer"
date: 2010-12-03T18:08:09+01:00
tags:
- wordpress
---

Utilisateurs Wordpress, si vous avez installé [W3 Total Cache](http://wordpress.org/extend/plugins/w3-total-cache/), que vous utilisez la mise en cache de pages et que votre thème dispose de feuilles de styles alternatives pour Internet Explorer, alors ce billet peut vous être utile.

Etant de ce clan, j'ai fait une mauvaise découverte ce matin sur un wordpress ... Le site distribuait les feuilles IE6 à tout le monde ... Le problème ? La page a été affichée en premier, et donc mise en cache, par un internaute qui tournait sous Internet Explorer 6 (_oui, quel malheur !_) injectant ainsi les styles supplémentaires pour ce navigateur.

La solution réside dans la fonctionnalité "Rejected User Agents" de W3 Total Cache qui permet d'interdire la mise en cache pour certains navigateurs. Il suffit donc d'ajouter MSIE dans la liste, et plus aucune version d'Internet Explorer n'utilisera ou générera la "version cachée" d'une page.

![Screenshot](Screenshot-74-1.png)
