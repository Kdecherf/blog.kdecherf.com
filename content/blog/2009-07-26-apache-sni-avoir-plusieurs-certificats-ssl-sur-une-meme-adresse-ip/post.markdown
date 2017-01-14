Date: 2009-07-26 00:05:26
Title: Apache + SNI : avoir plusieurs certificats SSL sur une même adresse IP
Category: Blog
Tags: apache, sni

De nombreux utilisateurs de serveurs web ont déjà été confrontés au drame : ne pas pouvoir mettre plus d'un certificat SSL sur une même adresse IP. La solution à ce fâcheux problème porte un nom : **SNI** (_Server Name Indication_).

### Origine du problème

Le problème vient de l'implémentation du protocole SSL. Lors d'une requête l'adresse hôte est dans le paquet de la couche Transport, elle est donc illisible lors du chiffrement, par conséquent le serveur web n'a aucun moyen de savoir quel site est demandé et par extension quel certificat doit être utilisé pour déchiffrer la requête.

### Solution

La version 3 du protocole **SSL** ainsi que le protocole **TLS** intègrent un nouveau champ d'en-tête permettant de préciser quel hôte on veut. Ainsi, Apache peut choisir un certificat SSL selon l'adresse demandée.

### Inconvénients

Cette solution possède 2 inconvénients : côté serveur on doit recompiler apache/mod\_ssl pour la prise en charge de **SNI**, côté client le navigateur internet doit également prendre en charge **SNI** sous peine de ne jamais recevoir le bon certificat SSL.

Le premier point reste moindre, le deuxième point tend à disparaitre bien que j'ai remarqué divers défaillances SNI sur **Firefox 3.0**.

### Mise en place

Pour tous les systèmes gérant les dépendances, il suffit d'ajouter la dépendance SNI à Apache (_exemple, ajoutez **sni** à USE sur Gentoo_). Il se peut que votre version de *mod_ssl / OpenSSL* ne gère pas le SNI, dans ce cas utilisez *mod_gnutls / GnuTLS*. Pour les systèmes à gestionnaire de paquets _pour assistés_ (style Debian, Ubuntu), le SNI devrait être intégré d'office mais pas sûr.

Il n'y a pas grand chose de plus à faire si ce n'est interdire l'utilisation de la version 2 du protocole SSL dans les fichiers de configuration Apache :

``` apache
                SSLProtocol all -SSLv2
                SSLEngine on
                SSLCertificateFile yourkey.crt
                SSLCertificateKeyFile yourkey.key[/text]
```

Et voilà, logiquement vous pouvez désormais utiliser différents certificats SSL sur une même adresse IP.
