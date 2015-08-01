Date: 2011-06-19 19:47:34
Title: Java : un équivalent à Iconv//TRANSLIT
Category: Tips
Slug: java-equivalent-iconv-translit

Il y a deux ans j'avais publié un petit billet sur le [nettoyage d'accents en PHP à l'aide d'Iconv](/2009/04/14/php-nettoyer-des-accents-simplement-avec-iconv/). J'ai eu besoin de faire la même chose en Java récemment, seulement le mode //TRANSLIT n'existe pas.

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
