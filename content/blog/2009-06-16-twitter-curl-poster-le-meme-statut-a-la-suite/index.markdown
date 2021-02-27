Date: 2009-06-16 01:00:45
Title: Twitter + Curl : poster le même statut à la suite
Category: Blog
Tags: curl,twitter

Dans certains cas, la même chose doit être tweetée (rapport d'erreur sur le même serveur, connexion ...) mais par défaut c'est interdit sur Twitter. Voici donc une solution simple mais efficace pour passer outre cette limitation. _Cet article est destiné aux personnes utilisant des robots de monitoring sur Twitter via Curl (Nagios, Fail2ban)._

![Twitter]({attach}twitter-logo.jpg)
{: .image}

> 
> _Twitter will ignore attempts to perform a duplicate update. With each update attempt, the application compares the update text with the authenticating user's last successful update, and ignores any attempts that would result in duplication. Therefore, a user cannot submit the same status twice in a row. The status element in the response will return the id from the previously successful update if a duplicate has been silently ignored._

Comme il est dit dans le message sur le Wiki API de Twitter, le message à l'identique n'est jamais posté 2 fois. Il suffit donc de rajouter un " identifiant " à chaque tweet. Dans mon cas, je choisis l'affichage compressé de l'heure (_hhmmss_) :

``` bash
/usr/bin/curl -u user:pass -d status="[`date | cut -c 14,15,17,18,20,21`] Votre tweet" http://twitter.com/statuses/update.xml
```

_**Mise à jour**_ : les arguments du _cut_ sont valables pour un système avec _LC_TIME_ (ou à défaut _LC_ALL_) sur **en_US**

Ainsi nous obtenons le résultat suivant :

![twitter-curl1]({attach}twitter-curl1.png)
{: .image}

Vous pouvez aussi faire plus court à l'aide des usertags :

![twitter-curl-2]({attach}twitter-curl-2.png)
{: .image}

_Enjoy it !_
