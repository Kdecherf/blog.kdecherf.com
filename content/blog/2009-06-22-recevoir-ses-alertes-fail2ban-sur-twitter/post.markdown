Date: 2009-06-22 23:14:13
Title: Recevoir ses alertes Fail2ban sur Twitter
Category: Blog
Tags: fail2ban,twitter

Dans la série des articles inutiles mais utiles, voici comment recevoir ses alertes Fail2ban sur Twitter.

**Prérequis :**
	
  * [Twitter + Curl : poster le même statut à la suite](/blog/2009/06/16/twitter-curl-poster-le-meme-statut-a-la-suite/)
  * [Fail2ban : notifier chaque connexion SSH](/blog/2009/06/15/fail2ban-notifier-chaque-connexion-ssh/)

**Notifier les bannissements :**

Premier type d'alerte à mettre en place : les bannissements. Dans _/etc/fail2ban/jail.conf_, on ajoute une ligne pour exécuter **twitter-ban** :

``` bash
servert = server.example.com

[ssh-iptables]

enabled  = true
filter   = sshd
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           twitter-ban[name=SSH, server=%(servert)s]
logpath  = /var/log/sshd/current
maxretry = 3
```

_Pensez à changer **logpath** en conséquence._ Puis on ajoute _/etc/fail2ban/action.d/twitter-ban.conf_ :

``` bash
# Fail2Ban configuration file
[Definition]
actionstart =
actionstop =
actioncheck =

actionban = /usr/bin/curl -u user:pass -d status="[`date | cut -c 14,15,17,18,20,21`] <ip> has been banned from <server> (<name> attempt)" http://twitter.com/statuses/update.xml

actionunban =

[Init]
name = default
dest = root
```

_Remplacez user et pass par les informations du compte Twitter._

Et voilà, redémarrez Fail2ban et désormais il va tweeter chaque bannissement. Vous pouvez également tweeter le moment où une ip est débannie en ajoutant l'action à **actionunban**.

**Notification de connexion**

Dans la continuité de mon billet sur comment notifier chaque connexion SSH via Fail2ban, ajoutez l'action **twitter-notify** dans _/etc/fail2ban/jail.conf_ :

``` bash
[ssh-notify]

enabled  = true
filter   = sshd-notify
action   = mail-notify[name=SSH, dest=%(emailt)s, from=%(fromt)s, server=%(servert)s, serverip=%(serveript)s]
           twitter-notify[name=SSH, server=%(servert)s]
maxretry = 1
bantime  = 1
logpath  = /var/log/sshd/current
```

Puis _/etc/fail2ban/action.d/twitter-notify.conf_ :

``` bash
# Fail2Ban configuration file
[Definition]

actionstart =
actionstop =
actioncheck =

actionban = /usr/bin/curl -u user:pass -d status="[`date | cut -c 14,15,17,18,20,21`] <ip> connected on <server>/<name>" http://twitter.com/statuses/update.xml

actionunban =

[Init]
name = default
dest = root
```

Et voilà, si le flood de vos amis sur Twitter ne vous suffisait pas alors Fail2ban devrait y remédier. _Enjoy It_.
