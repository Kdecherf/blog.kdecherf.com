---
title: "RSA : 768 bits c'est has been, passe à 1024"
date: 2010-01-17T19:21:13+01:00
slug: rsa-768-bits-cest-has-been-passe-1024
---

Il fallait s'y attendre, le 12 décembre dernier une équipe de chercheurs dirigée par T. Kleinjung a réussi à factoriser une clé RSA de **768 bits**, le projet aura duré **un an et demi**.


Pour ceux qui ne connaissent pas, l'algorithme **RSA** (_Rivest Shamir Adleman_) est un algorithme de chiffrement asymétrique à clé publique. Cet algorithme a été introduit en 1977 par [_Ron Rivest_](http://fr.wikipedia.org/wiki/Ron_Rivest), [_Adi Shamir_](http://fr.wikipedia.org/wiki/Adi_Shamir) et [_Len Adleman_](http://fr.wikipedia.org/wiki/Len_Adleman).

Je ne vais pas m'étendre sur la présentation de cet algorithme, [Wikipedia](http://fr.wikipedia.org/wiki/Rivest_Shamir_Adleman) le fait très bien. Si vous voulez en savoir plus sur le mechanisme de fonctionnement, vous pouvez toujours vous référer à {{< wayback "http://www.siteduzero.com/tutoriel-3-2170-la-cryptographie-asymetrique-rsa.html" >}}l'article du Site du Zéro{{< /wayback >}}.

Partant de ce principe, nous ne pouvons pas parler de "casser" l'algorithme mais de factorisation de clé. La consommation en ressources dépend directement de la taille de clé, sachant que pour une clé 768 bits il faut approximativement **1 500 ans** pour la factoriser à l'aide un Opteron 2.20 Ghz. Le résultat final occupe pas moins de 5 To et a demandé plusieurs centaines de machines. Vous trouverez le PDF du projet [ici](http://eprint.iacr.org/2010/006.pdf).

Jusqu'en mai 2007, les laboratoires RSA organisaient le **concours de factorisation RSA** avec un bon prix selon la taille de clé factorisée. Si le concours était encore d'actualité, T. Kleinjung et son équipe auraient touché [50 000 dollars](http://fr.wikipedia.org/wiki/Comp%C3%A9tition_de_factorisation_RSA).

Le NIST recommande donc de passer sur des clés d'une taille minimale de 1024 bits. Une hypothèse très controversée indique que les clés de 1024 bits pourraient être factorisées d'ici la fin de l'année étant donné que le rapport puissance de calcul / machine augmente sensiblement. La taille la plus répandue reste 2048 bits, et pour les paranos vive les clés de 4096 bits :)


Petite information à part pour les personnes qui se posent des questions au regard de la loi française : sachez que depuis le 21 juin 2004, la [Loi pour la Confiance dans l'Economie Numérique](http://fr.wikipedia.org/wiki/Loi_pour_la_confiance_dans_l'%C3%A9conomie_num%C3%A9rique) a totalement libéralisé l'utilisation des algorithmes de chiffrement à l'intérieur du pays (l'import / export est soumis à certaines règles). Pour plus d'informations sur les règlementations en matière de sécurité des données en France, visitez le [site](http://www.ssi.gouv.fr/) de l'Agence Nationale de la Sécurité des Systèmes d'Information.
