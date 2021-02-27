Title: Gérer les encours de CB à débit différé avec HomeBank
Category: Blog
Tags: homebank,awk,qif
Date: 2020-04-18 18:23:46

Ne sachant pas si ce qui suit est répandu ailleurs, j'écris ce billet en
français.

J'ai migré sur une carte bancaire à débit différé il y a quelques mois. Outre la
différence que l'on connait avec les cartes à débit immédiat, il a fallu que
j'adapte ma façon d'intégrer et de suivre mes transactions dans [HomeBank][1].

Avec une carte à débit immédiat, les transactions CB apparaissaient en quelques
jours sur le relevé du compte principal, avec la date de transaction dans
l'intitulé (_ex: `CB FOOBAR FACT 010120`_). Désormais, la carte à débit différé
dispose d'un compte dédié pour son encours. Les transactions sont réintégrées
sur le compte principal une fois par mois, à la date de règlement de cet encours.

En résumé :

 1. Je paie avec la carte, la transaction s'affiche en quelques jours sur le
    compte d'encours à la date de transaction
 2. Le jour de règlement de l'encours, la transaction devient visible sur le
    compte principal au jour courant avec la date de transaction dans l'intitulé

Du côté de HomeBank j'ai décidé de faire un nouveau compte séparé pour la carte,
les transactions y sont intégrées régulièrement via le relevé du compte
d'encours. Sans rien changer aux relevés obtenus de ma banque, une fois par mois
toutes les transactions CB du mois passé se manifesteraient sur le compte
principal sans tenir compte de leur existence sur le compte d'encours.

Utilisant le format QIF[^1] pour les autres relevés de cette banque, j'ai choisi
de conserver ce format de fichier et de le transformer pour que toutes les
transactions CB se présentant sur le relevé du compte principal soient
regroupées en une transaction globale.

J'ai déjà écrit des scripts `awk` par le passé pour manipuler des fichiers CSV
[provenant de PayPal][2] et de N26. `awk` étant simple mais puissant, surtout
quand il est question d'expressions rationnelles, j'ai décidé de continuer avec
lui pour ce nouveau format. La grande différence étant ici que le séparateur de
champs est un retour à la ligne, ce qui nécessite de changer `FS` et `RS`.

``` awk
#!/usr/bin/awk -f

BEGIN {
   FS="\n"
   RS="^"
}

# On imprime les lignes commençant par !
$1 ~ /^!/ { print $1 }

# On imprime les transactions sans lien avec la CB
$2 !~ /^$/ && $4 !~ /^PCB / { print $2; print $3; print $4; print $5; print RS }

# On met de côté toutes les transactions CB
$2 !~ /^$/ && $4 ~ /^PCB / {
   buckets[substr($2, 2)] += substr($3, 2)
}

END {
   for (pos in buckets) {
      # On imprime une entrée QIF pour chaque jour ayant des transactions CB
      # `D%s` pour afficher pos, la date au format chaîne de caractères
      # `T%.2f` pour afficher la somme des transactions sous forme de nombre à
      # virgule flottante à deux décimales
      printf("D%s\nT%.2f\nP\nMCB \n^\n", pos, buckets[pos])
   }
}
```

> Note: le script doit être adapté si votre banque ne formate pas les mouvements
  de la même façon.

Ce script awk regroupe toutes les transactions d'une même journée dont le
destinataire commence par `CB `. La transaction en découlant a un destinataire
vide (_`P`_) et le mémo `CB ` (_`MCB`_).

Prenons le fichier `monfichier.qif` :

``` qif
!Type:Bank
D24/11/19
T-1.11
PCB TOTO FACT 221119
MCB TOTO FACT 221119
^
D24/11/19
T-23.45
PCB FOOBAR FACT 231119
MCB FOOBAR FACT 231119
^
D25/11/19
T-4.12
PPRLV BAZ
MPRLV BAZ
^
```

La commande `monfichier.awk monfichier.qif` va produire le fichier QIF suivant :

``` qif
!Type:Bank
D25/11/19
T-4.12
PPRLV BAZ
MPRLV BAZ
^
D24/11/19
T-24.56
P
MCB 
^
```

On peut ainsi voir que les deux transactions CB vers _Toto_ et _Foobar_ ont été
regroupées en une transaction d'un montant de 24.56.

La transaction ainsi importée dans HomeBank pourra servir de transfert interne
entre le compte principal et le compte d'encours afin d'avoir une balance
équilibrée.

_Enjoy_

[1]: http://homebank.free.fr
[2]: {filename}/blog/2013-12-18-import-paypal-transaction-history-in-homebank/post.markdown

[^1]: Le format QIF, pour _Quicken Interchange Format_ est un format de fichier répandu dans le milieu bancaire, voir [wikipedia](https://en.wikipedia.org/wiki/Quicken_Interchange_Format)
