---
title: "Fail2ban : Créer un rapport quotidien"
date: 2009-04-25T15:55:43+02:00
tags:
- fail2ban
---

Après l'article pour [transformer les mails Fail2ban façon Nagios]({filename}/blog/2009-03-27-fail2ban-email-alerte-facon-nagios/post.markdown), voici un petit article pour générer des rapports journaliers de l'activité de votre chien de garde favori.

![fail2ban]({attach}fail2ban_logo.png)
{: .image}

L'idée générale de l'article est de changer le système par défaut de Fail2Ban qui vous envoie un email à chaque bannissement. Si vous regardez les actions disponibles vous pouvez y trouver _mail-buffered_. Cette action attend 5 bannissements (par défaut) avant de vous envoyer un email.

On va utiliser ce dernier, mais au lieu d'avoir un email tous les _x_ bannissements on va avoir le rapport tous les jours à une heure précise.

**Action Fail2Ban**

Sur la base de _mail-buffered.conf_ donc, on va créer _mail-daily.conf_ dans _/etc/fail2ban/action.d/_

``` bash
[Definition]

actionstart = echo -en "***** Fail2Ban *****\n\nNotification Type: RECOVERY\n\nService: <name>\nHost: <server>\nAddress: <serverip>\nState: STARTED\n\nDate/Time: `date`\n\nAdditional Info:\n\n" | mail -a "From: <from>" -s "** RECOVERY alert - <server>/<name> jail is STARTED **" <dest>

actionstop = echo -en "***** Fail2Ban *****\n\nNotification Type: ALERT\n\nService: <name>\nHost: <server>\nAddress: <serverip>\nState: STOPPED\n\nDate/Time: `date`\n\nAdditional Info:\n\n" | mail -a "From: <dest>" -s "** ALERT alert - <server>/<name> jail is STOPPED **" <dest>

actioncheck =

actionban = echo `date | awk -F ' ' '{print $4}'`" - <ip> (<failures> attempts against <name>)" >> <tmpfile>

actionunban =

[Init]

tmpfile = /tmp/fail2ban-mail.txt

# default dest
dest = root
```

Comme vous pouvez le constater, nous utilisons la forme Nagios pour les mails. Concrètement, à un bannissement fail2ban ajoute une ligne au fichier de stockage temporaire (ici _/tmp/fail2ban-mail.txt_) avec quelques infos : IP, service attaqué et tentatives. L'envoi même du rapport par mail ne s'effectue pas ici.

**Configuration Fail2ban**

On reprend la configuration fail2ban de l'ancien article et on y change une petite ligne. Ici nous prenons l'exemple du service SSH qui a, pour action mail par défaut, _mail-whois_. Fichier_ /etc/fail2ban/jail.conf_

``` bash
fromt   = Fail2ban
servert = host.example.com
serveript = 127.0.0.1
emailt  = webmaster@example.com

[ssh-iptables]

enabled  = true
filter   = sshd
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           mail-daily[name=SSH, dest=%(emailt)s, from=%(fromt)s, server=%(servert)s, serverip=%(serveript)s]
logpath  = /var/log/sshd/current
maxretry = 3
```

Pensez à modifier les 4 premières lignes à votre guise. Changez _logpath_ en fonction de la configuration de votre système et changez _maxretry_ en fonction de vos besoins (ici bannissement au bout de 3 essais ratés).

Il nous reste une dernière étape : le script générant le rapport journalier.

**Génération du rapport**

Là est la particularité de la chose, le rapport n'est pas généré par Fail2ban même mais par un script bash tout bête. Voici _/etc/fail2ban/action.d/report.sh_

``` bash
#!/bin/sh

SERVER="host.example.com"
IP="127.0.0.1"
FROM="Fail2ban "
TO="webmaster@example.com"

TMP=/tmp/fail2ban-mail.txt

if [ -f $TMP ]; then
echo -en "***** Fail2Ban *****\n\nNotification Type: INFO\n\nService: *\nHost: $SERVER\nAddress: $IP\nState: OK\n\nDate/Time: `date`\n\nAdditional Info:\n\nThese hosts have been banned on `date --date '1 days ago' +"%a %d %b"`\n`cat $TMP`" | mail -a "From: $FROM" -s "** INFO alert - $SERVER jail REPORT **" $TO
rm $TMP
fi
```

Tout comme le fichier de configuration, pensez à changer les 4 premières variables en fonction de vos besoins.

Vous l'aurez deviné, nous devons maintenant ajouter une tâche crontab :

``` bash
10 0 * * *      /etc/fail2ban/action.d/report.sh > /dev/null
```

Cette configuration génère et envoie un rapport tous les jours à 00h10. Vous pouvez naturellement changer ce paramétrage pour générer un rapport toutes les semaines seulement par exemple.

Vous n'avez plus qu'à redémarrer Fail2ban pour prendre en compte la nouvelle action.

_Enjoy It_ ;-)
