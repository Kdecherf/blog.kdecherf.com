Date: 2009-03-01 03:13:16
Title: Comparatif PHP : Unicode et echappement HTML
Category: Articles
Tags: [php]

Me voilà de retour pour un nouveau comparatif PHP. Le titre n'est peut-être pas super explicite alors je vais m'expliquer.

A mes débuts, j'ai eu pas mal de problèmes de _charset_. Entre les bases ISO-8859-1, des bouts de code UTF-8 et compagnie je finissais souvent par avoir les caractères que l'on a vu au moins une fois dans sa vie :)

Il fallait aussi compter sur les divergences des navigateurs qui ne choisissaient jamais le bon encodage (_finalement c'était de ma faute, pour dire_). Enfin bref, il m'est venu l'idée d'une fonction de conversion universelle qui transforme du texte aussi bien ISO-8859-1/15 qu'UTF-8 vers le format universel des caractères échappés en HTML (_&eacute;_ et compagnie ...) dont voici la [source](http://www.phpcs.com/codes/CONVERSION-UNIVERSELLE-CARACTERES_42236.aspx). Cool ! Oui mais en fait non. Pourquoi ?

**Avantages et inconvénients**

Commençons par l'échappement HTML. Le principe est de convertir tous les caractères spéciaux en leurs équivalents HTML (_&eacute; &agrave;_ ...). L'avantage premier est d'afficher les caractères correctement pour n'importe quel encodage choisi par le navigateur.

Cependant il y a quelques inconvénients, dans le cadre d'une fonction comme la mienne il faut convertir tous les textes à l'affichage et cela consomme énormément de ressources et ajoute du poids considérable à la page (_nous le verrons en détail plus bas_).

Concernant l'affichage direct du texte tel qu'il a été saisi ... l'avantage premier est de n'avoir aucun traitement intermédiaire. Cela implique cependant de bien vérifier qu'on impose l'encodage choisi pour éviter du _multi-charset _dans les bases de données. Par imposer l'encodage j'entends : balise Meta-Tag, en-tête Apache et connexion MySQL.

**Comparatif par l'exemple**

Passons aux exemples concrets. Dans cet exemple j'ai pris le texte tel quel de la page " [Préhistoire : Lascaux, grotte en péril](http://www.lemonde.fr/planete/article/2009/02/27/prehistoire-lascaux-grotte-en-peril_1161207_3244.html) ". Je ne vais parler que du format Unicode ici (_vous verrez plus bas pourquoi_).

**Taille**
	
  * Le texte au format UTF-8 fait très précisément **6 544 **octets
  * Le texte converti fait très précisément **8 099** octets

En conclusion sur la taille, il y a une différence de **1 555** octets. Petit me dites-vous ? Passons au modèle temporel ... Sur la base de 100 000 pages vues par mois
	
  * Le texte au format UTF-8 va générer un transfert de **654,4 **millions d'octets (~650 Mo)
  * Le texte converti va générer un transfert de **809,9** millions d'octets (~810 Mo)

Nous parlons donc ici d'une différence de transfert de **~155 Mo** par mois. Ce n'est rien ? Les têtes de mule :D Passons ces chiffres sur un site qui possède 10 000 articles comme celui là et qui génère 5 millions de pages vues par mois ... Ce n'est pas moins de **15 Mo** gagné sur le stockage et ... **7,8 Go** de transfert économisé par mois ! Vous comprenez mieux là ? Non ? Ok, passons côté performance ...

**Performance**

Pour ce test, nous allons nous limiter à la lecture du texte à partir d'un fichier, à sa conversion et à son affichage ... le tout exécuté 1 000 fois pour avoir une meilleure vision du temps.
	
  * Le texte en UTF-8 est lu et affiché en **13 ms** (_à l'unité_)
  * Le texte converti est lu, converti et affiché en **16.8 ms** (_à l'unité_)

Bon ... nous voilà avec **3.8 ms** de différence. Oui, c'est petit ... je vous l'accorde mais maintenant élargissez ça à 5 millions de pages vues ... Cela représente une différence de **19 000** secondes. Oui ! Il y a une différence de plus de **5 heures** de traitement par mois !

**Conclusion**

Conclusion ... Ais-je réellement besoin d'exposer ma conclusion personnelle ? :) En tout cas, vous l'aurez remarqué ... la conversion des caractères est une mauvaise idée pour du long terme. La solution reste d'envoyer du texte pur avec un encodage bien défini dans vos pages et vos bases.

**Débat : ANSI versus Unicode**

Le débat éternel ! Choisir ISO-8859-1 ou UTF-8 ? Ma réponse sera courte : UTF-8. Bien que cet encodage consomme quelques octets de plus par rapport à l'ISO, il permet néanmoins d'afficher sans mal les caractères chinois, russes ou encore arabes ...

_Note : ANSI regroupe les encodages de type ISO et CP1252 ... tandis que l'Unicode regroupe, entre autre, UTF-8, UTF-16 et UTF-32._

Aller plus loin : [présentation du format Unicode sur Wikipédia](http://en.wikipedia.org/wiki/Unicode)

**Bouts de code**

Balise meta-tag qui va bien
``` html
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
```

Ligne PHP qui va bien
``` php
<?php
header( 'Content-type: text/html; charset=utf-8' );
?>
```

Commande PHP qui va bien pour MySQL (_à faire après un mysql_connect_)
``` php
<?php
@mysql_set_charset( 'utf8' );
?>
```








J'espère que cet article vous a été utile tant bien sur le choix d'envoyer du texte pur ou encodé que sur le choix ISO/UTF.




_Note : à l'époque ma fonction partait d'un bon principe mais on voit que cela peut se révéler très très lourd._



