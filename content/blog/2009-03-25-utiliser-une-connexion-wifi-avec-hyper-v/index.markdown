---
title: "Utiliser une connexion WiFi avec Hyper-V"
date: 2009-03-25T02:27:03+01:00
tags:
- "hyper-v"
- windows
---

Si certains souhaitent ou utilisent Windows Server 2008 et (le rôle) Hyper-V sur un ordinateur portable, cette astuce pourrait vous être utile.

Il est rare d'être tout le temps connecté sur une prise Ethernet et il devient indispensable de pouvoir utiliser la connexion WiFi pour avoir internet sur nos machines virtuelles préférées, or Hyper-V ne prend pas en charge les réseaux WiFi. Une petite bidouille s'impose.

L'astuce est vraiment simple mais il faut y penser.
	
  * Dans **Virtual Network Manager**, ajoutez une interface réseau de type **Interne**. Ceci a pour conséquence de créer une nouvelle interface ethernet sur le système hôte.
  * Dans les propriétés de la connexion WiFi, onglet Partage, **partagez la connexion** puis sélectionnez l'interface fraichement créée.

![hyper-v-connections](hyper-v-connections.jpg)

C'est aussi simple que ça ! Pensez à ajouter l'interface réseau sur vos machines virtuelles et vous aurez désormais internet via votre connexion WiFi.
