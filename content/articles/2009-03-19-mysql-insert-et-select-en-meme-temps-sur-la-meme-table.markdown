Date: 2009-03-19 14:05:15
Title: MySQL : INSERT et SELECT en même temps sur la même table
Category: Tips
Tags: mysql

Peut-être vous est-il arrivé d'avoir la terrible erreur _1093 (HY000): You can't specify target table 'foo' for update in FROM clause_ en faisant une commande du genre

``` sql
INSERT INTO table1 SET column1=(SELECT column1 FROM table1 ORDER BY id DESC LIMIT 1)+1
```

A l'heure actuelle, et pour une raison douteuse, le serveur MySQL refuse ce genre de requête. Sans doute pour éviter le _télescopage_, bien que ça ne soit pas possible en vue des ordres d'exécution.

La solution à ce bug, en attendant sa correction, est tout simplement de **renommer la table dans le SELECT** de la façon suivante :

``` sql
INSERT INTO table1 SET column1=(SELECT column1 FROM table1 AS x ORDER BY id DESC LIMIT 1)+1
```

Pour expliquer un peu l'exemple, j'insère un enregistrement auquel j'assigne la dernière valeur disponible + 1 sur le champ column1. C'est utile sur des champs où on ne peut pas appliquer d'*auto_increment* et cela évite de faire une requête préliminaire dans le script final.

_Enjoy It !_
