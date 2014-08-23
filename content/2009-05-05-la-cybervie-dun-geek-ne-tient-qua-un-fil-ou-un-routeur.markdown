Date: 2009-05-05 01:35:47
Title: La (cyber)vie d'un geek ne tient qu'à un fil ... ou un routeur
Category: Articles

S'il y a bien quelque chose auquel il ne faut pas toucher chez un geek, outre son ordinateur, c'est bien **Internet** !

![frustrated](/images/2009/05/frustrated_1.jpg)

Combien d'entre nous ont subis de lourds dommages psychologiques à cause d'un dysfonctionnement de notre lien vital vers le (cyber)monde ?

"Maman a débranché le routeur" (si si, ça existe !), "Une voiture a couché le poteau France Telecom", "le DSLAM est isolé" ... Tant de misères pouvant nous arriver, nous privant de notre essence.

Il y a quelques temps, j'ai expérimenté un nouveau genre de défaillance bloquant totalement la navigation : la terrible _"boucle de routage"_. Le but du jeu ? Un routeur s'emmêle les pinceaux dans ses routes et envoie les paquets au mauvais routeur ... Ce dernier les renvoie au bon routeur qui est ... le premier. Ça donne un résultat similaire :

![easynet-infinite-router-loop1](/images/2009/05/easynet-infinite-router-loop1.jpg)

Là où c'est totalement frustrant, c'est que techniquement la connexion fonctionne ... Mais voilà !

Alors ça pourrait être un coup de gueule à EasyNet mais non en fait je ne fais pas un billet pour ça. Outre l'amusement que cela peut apporter, pendant ou après coup, il est important de voir l'arrière de la scène.

Internet est un réseau qui pourrait être assimilé à une topologie Arbre ou encore Maille. Autrement dit, certaines entités dépendent d'autres, certains liens sont critiques. Là où je veux en venir, c'est sur **l'importance de la redondance des liens et des machines** et surtout la **prévention des incidents**.

Ce petit message est destiné aux administrateurs réseau mais surtout aux personnes qui souhaitent se lancer dans cette branche. Un simple lien peut provoquer d'énormes pertes donc prévoyez large et ayez un système de surveillance qui tienne la route ;-)
