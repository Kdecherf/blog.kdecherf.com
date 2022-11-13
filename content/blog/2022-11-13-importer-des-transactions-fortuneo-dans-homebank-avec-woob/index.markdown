---
title: "Importer des transactions Fortuneo dans HomeBank avec woob"
date: 2022-11-13T20:02:17+01:00
tags:
- homebank
- woob
---

Cela fait maintenant une dizaine d'années que j'utilise HomeBank pour suivre
régulièrement mes dépenses et mes budgets. J'ai déjà eu l'occasion d'en parler
par le passé, notamment pour importer l'historique de transactions PayPal[^1]
ou encore gérer un historique de transactions avec un encours de carte bancaire
à débit différé[^2].

Me voilà de retour pour vous partager un script permettant d'importer un
historique de transactions Fortuneo, avec une nouveauté : l'utilisation de `woob`[^3]
pour récupérer l'historique.

Sans `woob` les historiques seraient à récupérer en téléchargeant une à une les
archives zip depuis l'interface client de Fortuneo, et cela ne me motivait pas
tellement.

Ayant également une carte à débit différé auprès de cette banque, j'appelle
deux fois woob : une première fois pour exporter les transactions par carte à
venir (_encours carte, avec_ `woob bank coming`) et la deuxième pour exporter
les transactions du compte courant (`woob bank history`). Je choisis également
d'en faire un export csv avec des champs sélectionnés, `rdate` pour la date de
transaction par carte et `date` pour les autres types de transaction.

```
woob bank -b fortuneo coming <accountnumber>@fortuneo -f csv -s "rdate,label,amount" > HistoriqueFortuneoComing.csv
woob bank -b fortuneo history <accountnumber>@fortuneo -f csv -s "date,label,amount" > HistoriqueFortuneoCourant.csv
```

Une fois les fichiers récupérés, nous pouvons nous servir du script awk suivant
pour rendre l'export compatible avec le format d'import[^4] de HomeBank :

``` awk
#!/usr/bin/awk -f

BEGIN {
   FS=";"
   RS="\r\n"
}

{
   if (NR > 1) {
      if ($2 !~ /^CARTE [0-9]{2}\/[0-9]{2}/) {
         printf("%s;0;;%s;%s;%s;;\n", $1, $2, $2, $3);
      } else {
         buckets[$1] += $3
      }
   }
}

END {
   for (pos in buckets) {
      label = "Cb Diff"
      printf("%s;0;;%s;%s;%.2f;;\n", pos, label, label, buckets[pos])
   }
}
```

_Note : comme pour le précédent article traitant d'une carte à débit différé,
je rajoute une logique chargée de fusionner tous les mouvements par carte
apparaissant sur le compte courant car ils correspondent au moment où l'encours
est appliqué._

Je fais une petite boucle pour passer sur tous les fichiers :

``` bash
for i in HistoriqueFortuneo*csv ; do hb-fortuneo.awk $i > fortuneo-$i ; done
```

Les fichiers qui en résultant peuvent maintenant être importés dans HomeBank.

_Enjoy!_

[^1]: https://kdecherf.com/blog/2013/12/18/import-paypal-transaction-history-in-homebank/
[^2]: https://kdecherf.com/blog/2020/04/18/gerer-les-encours-de-cb-a-debit-differe-avec-homebank/
[^3]: https://woob.tech/
[^4]: Format de fichier CSV pour HomeBank http://homebank.free.fr/help/misc-csvformat.html

