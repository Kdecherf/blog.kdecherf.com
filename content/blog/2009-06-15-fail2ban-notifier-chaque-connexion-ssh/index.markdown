---
title: "Fail2ban : notifier chaque connexion SSH"
date: 2009-06-15T21:13:20+02:00
tags:
- fail2ban
---

Bien que Fail2Ban fasse correctement son travail, il peut arriver qu'une intrusion se fasse avec succès. Il peut être utile, par précaution ou aussi pour du suivi, de savoir quand quelqu'un se connecte sur SSH.

![fail2ban]({attach}fail2ban_logo.png)
{: .image}

Si vous connaissez bien Fail2ban, vous savez que tout se fait via des actions et des filtres, donc notre objectif ne sera pas dur à atteindre. Commençons par ajouter notre filtre dans _/etc/fail2ban/jail.conf_ :

Le formatage des mails utilisé ici est disponible [sur ce billet]({filename}/blog/2009-03-27-fail2ban-email-alerte-facon-nagios/post.markdown).

``` bash
[ssh-notify]

enabled  = true
filter   = sshd-notify
action   = mail-notify[name=SSH, dest=%(emailt)s, from=%(fromt)s, server=%(servert)s, serverip=%(serveript)s]
maxretry = 1
bantime  = 1
logpath  = /var/log/sshd/current
```

  * _maxretry = 1_ : Executer " actionban " à chaque connexion
  * _bantime = 1_ : Ne pas garder l'état de bannissement
  * _logpath = .._ : A modifier en fonction de votre système, journal courant des connexions SSH

Continuons avec _/etc/fail2ban/filter.d/sshd-notify.conf_ qui contient l'expression régulière pour les connexions SSH correctement établies :

**UPDATE :** la regex a été mise à jour en reprenant le [manuel](http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Filters), _HOST_ est devenu obligatoire.

``` bash
[Definition]

failregex = Accepted [-/\w]+ for .* from <HOST>

ignoreregex =
```

Il ne reste plus que le fichiers des actions à créer. Éditez _/etc/fail2ban/action.d/mail-notify.conf_ :

``` bash
[Definition]

actionstart =
actionstop =
actioncheck =

actionban = echo -en "***** Fail2Ban *****\n\nNotification Type: NOTIFY\n\nService: <name>\nHost: <server>\nAddress: <serverip>\nState: OK\n\nDate/Time: `date`\n\nAdditional Info:\n\n<ip>" | mail -a "From: <from>" -s "** NOTIFY alert - new connection on <server>/<name> **" <dest>

actionunban =

[Init]
# Default name of the chain
#
name = default
# Destination/Addressee of the mail
#
dest = root
```

Vous pouvez dès à présent redémarrer Fail2ban, désormais à chaque connexion vous devriez recevoir un email de ce genre :

![ssh-fail2ban-notify]({attach}ssh-fail2ban-notify.png)
{: .image}

Enjoy it ;-)
