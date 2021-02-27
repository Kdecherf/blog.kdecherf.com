Date: 2009-03-27 23:58:39
Title: Fail2ban : email d'alerte façon Nagios
Category: Blog
Tags: fail2ban
Slug: fail2ban-email-alerte-facon-nagios

Vous êtes accrocs aux emails d'alerte de votre cher Nagios et vous détestez les emails _par défaut_ de Fail2Ban ? Alors voici une astuce pour vous.

Transformez vos emails Fail2Ban selon le style Nagios :

Les actions de type email sont à mettre dans les fichiers `actions.d/*.conf` adéquats. Ici je donne l'exemple sur l'envoi d'un email au démarrage et à l'arrêt de fail2ban :

``` bash
actionstart = echo -en "***** Fail2Ban *****\n\nNotification Type: RECOVERY\n\nService: <name>\nHost: <server>\nAddress: <serverip>\nState: STARTED\n\nDate/Time: `date`\n\nAdditional Info:\n\n" | mail -a "From: <from>" -s "** RECOVERY alert - <server>/<name> jail is STARTED **" <dest>
actionstop = echo -en "***** Fail2Ban *****\n\nNotification Type: ALERT\n\nService: <name>\nHost: <server>\nAddress: <serverip>\nState: STOPPED\n\nDate/Time: `date`\n\nAdditional Info:\n\n" | mail -a "From: <from>" -s "** ALERT alert - <server>/<name> jail is STOPPED **" <dest>
```

Il faut également renseigner de nouvelles informations dans `jail.conf` selon le schéma suivant (exemple avec le filtre SSH et l'action `mail-whois`) :

``` bash
fromt   = Fail2Ban <fail2ban@example.com>
servert = myserver.example.com
serveript = 127.0.0.1
emailt  = Me <me@example.com>

[ssh-iptables]

...
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           mail-whois[name=SSH, dest=%(emailt)s, from=%(fromt)s, server=%(servert)s, serverip=%(serveript)s]
```

Redémarrez Fail2ban, vous devriez recevoir le nouvel email au démarrage :

``` text
***** Fail2Ban *****

Notification Type: RECOVERY  

Service: SSH  
Host: myserver.example.com  
Address: 127.0.0.1  
State: STARTED  

Date/Time: Sun Mar 22 03:15:59 CET 2009  

Additional Info:
```

Bien entendu, je vous conseille d'utiliser ce format _surtout_ pour les alertes du type rapport (MAJ : [Fail2Ban: Générer des rapports quotidiens]({filename}/blog/2009-04-25-fail2ban-creer-un-rapport-quotidien/post.markdown)).
