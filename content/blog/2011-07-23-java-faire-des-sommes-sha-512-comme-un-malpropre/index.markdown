---
title: "Java : faire des sommes SHA-512 comme un malpropre"
date: 2011-07-23T22:57:16+02:00
tags:
- java
---

Ou comment perdre plusieurs heures sur un problème bien planqué et très con. Dans le cadre d'un projet je devais stocker la somme SHA-512 de chaînes de caractères. Je suis parti à la recherche d'un bout de code pour faire ce que je voulais et j'ai trouvé le code suivant :

``` java
      md.update(myString.getBytes());
      byte[] mb = md.digest();
      StringBuilder hexString = new StringBuilder();
      for (int i = 0; i < mb.length; i++) {
         hexString.append(Integer.toHexString(0xFF & mb[i]));
      }
```

On calcule la somme d'un mot et on obtient ceci :


    f4baf3aec5ea176f1e641bdfaa1fa8fc25b7d6275b2690df1da571d6dc8bc8293923f2245bdb57be5a20a274612b9ccb232d91e9d840db4a6c62709d80f92e

Et un sha512sum (dans un terminal) pour le même mot nous donne ceci :

    f4baf3aec5ea176f01e641bdfaa1fa8f0c25b7d6275b2690df1da571d6dc8bc8293923f2245bdb57be5a20a274612b9ccb232d91e9d840db4a6c62709d80f92e

Avez-vous remarqué que bien qu'elles se ressemblent, ces chaînes ne correspondent pas ?  

La première fait 126 caractères alors qu'une somme SHA-512 doit en faire 128 ... Je vous laisse trouver les deux caractères manquants ... Vous m'en voulez ? Ok, les deux caractères manquants sont ... des 0.

Mais pourtant il y en a déjà dans les deux chaînes, non ? En effet. Après quelques heures de recherche je me lance la suggestion suivante sachant qu'on calcule la somme par pas de deux caractères hexadécimaux : et si le 0 de gauche n'était jamais ajouté ?  
Je me penche sur la méthode _Integer.toHexString()_ en regardant la Javadoc :

> This value is converted to a string of ASCII digits in hexadecimal (base 16) with no extra leading 0s

TOUT S'EXPLIQUE. Du coup, on doit rajouter un zéro à la main quand il le faut :

``` java {hl_lines=["7-10"]}
      MessageDigest md = MessageDigest.getInstance("SHA-512");

      md.update(myString.getBytes());
      byte[] mb = md.digest();
      StringBuilder hexString = new StringBuilder();
      for (int i = 0; i < mb.length; i++) {
         Integer n = 0xFF & mb[i];
         if (n < 16) {
            hexString.append("0");
         }
         
         hexString.append(Integer.toHexString(n));
      }
```

La morale de cette histoire : coder la nuit pour trouver ce genre d'erreur, c'est cool.

_Enjoy it !_

_PS : j'offre une bière à la première personne qui trouve le mot correspondant à cette somme SHA-512 :)_
