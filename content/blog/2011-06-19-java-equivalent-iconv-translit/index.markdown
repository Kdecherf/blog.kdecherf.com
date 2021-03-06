---
title: "Java : un équivalent à Iconv//TRANSLIT"
date: 2011-06-19T19:47:34+02:00
slug: java-equivalent-iconv-translit
tags:
- java
---

Il y a deux ans j'avais publié un petit billet sur le [nettoyage d'accents en PHP à l'aide d'Iconv]({{< ref "/blog/2009-04-14-php-nettoyer-des-accents-simplement-avec-iconv/index.markdown" >}}). J'ai eu besoin de faire la même chose en Java récemment, seulement le mode //TRANSLIT n'existe pas.

Fort heureusement, une petite recherche m'a permis de trouver [mon bonheur](http://stackoverflow.com/questions/5806690/is-there-an-iconv-with-translit-equivalent-in-java) :

``` java
String decomposed = Normalizer.normalize(accented, Normalizer.Form.NFKD);
StringBuilder buf = new StringBuilder();
for (int idx = 0; idx < decomposed.length(); ++idx) {
  char ch = decomposed.charAt(idx);
  if (ch < 128)
    buf.append(ch);
}
String filtered = buf.toString();
```

En résumé, ce bout de code décompose les caractères accentués en suite de caractères simples (exemple : è donne e`) puis ne conserve que les caractères ASCII (code ASCII < 128).

_Enjoy it !_
