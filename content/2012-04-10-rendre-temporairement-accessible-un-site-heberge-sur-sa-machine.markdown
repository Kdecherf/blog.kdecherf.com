---
layout: post
title: "Rendre temporairement accessible un site hébergé sur sa machine"
date: 2012-04-10 17:22
comments: true
categories: [Articles] 
---

Avec le passage de mon blog de Wordpress à Jekyll/Octopress, j'ai été confronté à un problème existentiel : comment diffuser un billet en cours de rédaction pour lecture "privée" sans le publier ?

Jekyll dispose d'un mode "serveur embarqué" afin d'avoir accès aux pages en local, il ne me reste plus qu'à supprimer la limite du réseau local et la version en développement pourra être accessible depuis _les internets_.
A défaut d'avoir une adresse IPv6, qui arrangerait tous nos problèmes, nous avons plusieurs solutions à notre disposition pour rendre accessible sur la toile un site hébergé localement :

 * Redirection de port sur sa box, mais c'est une technique limitée à son propre réseau
 * Installation d'un VPN sur une machine distante, mais c'est sortir le char pour tuer une mouche
 * Utilisation d'un tunnel SSH, similaire dans l'idée à l'installation d'un VPN mais beaucoup plus simple à mettre en place

Bien entendu, je vais vous présenter la solution la plus portable : un tunnel SSH.

A ce stade vous pouvez y accéder via un port spécifique. Si vous souhaitez rendre accessible le site via un sous-domaine (ou un sous-dossier), la suite de l'article est pour vous.

### Principe

![Principe](/images/2012/04/temporary-online.png)

Je pars du principe que nous disposons d'un serveur avec un serveur web qui écoute sur le port 80 et d'un laptop avec le serveur web local qui écoute sur le port 4000.

L'idée est de se servir d'un reverse proxy pour pouvoir mapper plusieurs serveurs web sur le même port et ainsi pouvoir jouer avec les domaines/sous-domaines pour rediriger correctement. Si vous êtes à l'aise avec Apache vous pouvez jouer avec, personnellement je préfère [HAProxy](http://haproxy.1wt.eu/).  
Le reverse proxy va écouter sur le port 80 et diffuser les requêtes entrantes, en fonction de critères que nous allons définir plus bas, aux différents serveurs : le serveur web actuel peut écouter sur le port 127.0.0.1:80 (_pour l'exemple_) et vous réservez un port pour le tunnel SSH (_8001 dans l'exemple_). Ensuite ce tunnel SSH servira à faire communiquer le port local 8001 du serveur avec le port local 4000 du laptop.


### Reverse proxy

La première étape est donc de migrer votre serveur web actuel sur un port local uniquement, si vous utilisez Apache `Listen 127.0.0.1:80` fera l'affaire. Pensez à changer les directives VirtualHost et NameVirtualHost en conséquence.

Si vous utilisez HAProxy comme reverse proxy, la configuration pour notre exemple doit ressembler à ça :

```
[...]
frontend webfront
        bind ippubliqueduserveur:80

        default_backend cluster_local

backend cluster_local
        mode http
        option  httplog
        option httpclose        #Disable keepalive
        option forwardfor
        balance roundrobin
        server  apache 127.0.0.1:80 check inter 2000 rise 2 fall 5
        errorfile       400     /etc/haproxy/errors/400.http
        errorfile       403     /etc/haproxy/errors/403.http
        errorfile       408     /etc/haproxy/errors/408.http
        errorfile       500     /etc/haproxy/errors/500.http
        errorfile       502     /etc/haproxy/errors/502.http
        errorfile       503     /etc/haproxy/errors/503.http
        errorfile       504     /etc/haproxy/errors/504.http
```

> Remarque : si vous ne précisez pas l'adresse IP publique du serveur, HAProxy va rentrer en conflit avec Apache en écoutant sur 0.0.0.0:80


### Tunnel SSH

En suivant l'exemple, la commande ssh à lancer sur le laptop pour rediriger le port 8001 du serveur sur le port 4000 [du laptop] est :
```
ssh -N -R127.0.0.1:8001:127.0.0.1:4000 monserveur
```

Je vous laisse lire le manuel très complet pour comprendre les deux options utiles ;-)

### Configuration du reverse proxy

Une fois que le tunnel est prêt, on peut finir la configuration du reverse proxy.

Dans l'exemple je vais rediriger preview.kdecherf.com vers le port 8001 (_qui redirigera sur le port 4000 de mon laptop_).

```
[...]

frontend webfront
        bind ippubliqueduserveur:80

        acl is_preview_kdecherf_com hdr_dom(host) -i preview.kdecherf.com

        use_backend cluster_preview if is_preview_kdecherf_com
        default_backend cluster_local

[...]

backend cluster_preview
        mode http
        option httplog
        option httpclose
        option forwardfor
        balance roundrobin
        server  rakeup 127.0.0.1:8081 check inter 2000 rise 2 fall 5
        errorfile       400     /etc/haproxy/errors/400.http
        errorfile       403     /etc/haproxy/errors/403.http
        errorfile       408     /etc/haproxy/errors/408.http
        errorfile       500     /etc/haproxy/errors/500.http
        errorfile       502     /etc/haproxy/errors/502.http
        errorfile       503     /etc/haproxy/errors/503.http
        errorfile       504     /etc/haproxy/errors/504.http
```

Pour résumer ce qui se passe :

 * Toutes les requêtes ayant pour host `preview.kdecherf.com` sont redirigées vers le cluster `cluster_preview`
 * Les autres requêtes (`default_backend`) sont redirigées vers le cluster `cluster_local`

Et voilà, tout simplement. Libre à vous d'ajouter des clusters et des ACL pour ajouter d'autres redirections et d'autres ports.

### Quid du référencement

Tous ceux qui ont déjà mis en ligne une version de test d'un site ont surement connu cette sensation désagréable quand on remarque que Google est déjà passé par là (_merci Chrome, entres autres_). Plutôt que de devoir penser à mettre un robots.txt à chaque fois qu'on veut rendre accessible un site, on va plutôt utiliser une autre ACL d'HAProxy pour servir le fichier depuis un autre cluster :

```
[...]
frontend webfront
        bind ippubliqueduserveur:80

        acl is_preview_kdecherf_com hdr_dom(host) -i preview.kdecherf.com
        acl is_robots_txt path_beg /robots.txt

        use_backend cluster_local if is_preview_kdecherf_com is_robots_txt
        use_backend cluster_preview if is_preview_kdecherf_com
        default_backend cluster_local
[...]
```

Qu'est-ce qui se passe ? Si la requête a comme host `preview.kdecherf.com` et que le chemin commence par `/robots.txt` alors on redirige vers le cluster `cluster_local`. On met cette condition en premier car le premier bloc `use_backend` qui a toutes ses conditions vraies stoppe les tests (*équivalent de [L] avec mod_rewrite*).
Sur le cluster local (_Apache par exemple_) on va ajouter un fichier robots.txt dans le dossier du VirtualHost par défaut pour ne pas dépendre du sous-domaine appelé.

Dans l'ordre, le test donne :

 * Si la requête a comme host `preview.kdecherf.com` et commence par `/robots.txt` alors on redirige vers `cluster_local`
 * Si la requête a comme host `preview.kdecherf.com` alors on redirige vers `cluster_preview`
 * Pour le reste on redirige sur `cluster_local`


### Quid de la sécurité

Etant donné que seules les requêtes HTTP passent, les seules failles pouvant être exploitées lorsque vous diffusez votre site sont les failles de l'application elle-même. Alors faites attention ;-)


### Quid des communications chiffrées

Si vous souhaitez mettre en place un accès HTTPS tout en ayant les ACL du reverse proxy, vous devrez utiliser une solution telle que STunnel en amont. En revanche si vous n'avez pas d'ACL à faire jusqu'à votre poste, vous pouvez activer HAProxy en mode TCP et gérer les communications SSL directement en local.


&nbsp;


Et voilà, vous pouvez désormais diffuser une appli web locale :-)  
Quand vous coupez l'accès au serveur local, le reverse proxy renverra une erreur _503 Service Unavailable_ jusqu'à sa prochaine apparition.
