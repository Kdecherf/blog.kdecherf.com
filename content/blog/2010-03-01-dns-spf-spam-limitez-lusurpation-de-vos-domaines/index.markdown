Date: 2010-03-01 02:10:53
Title: DNS/SPF - Spam : limitez l'usurpation de vos domaines
Category: Blog
Tags: dns
Slug: dns-spf-spam-limitez-lusurpation-de-vos-domaines

De nos jours, les pirates n'hésitent pas à usurper des noms de domaine pour envoyer du spam. Outre le fait d'embêter les filtres cela amène parfois à un blocage pur et simple du domaine incriminé, ce qui n'est pas négligeable dans un contexte professionnel : altération et blocage des communications ... Une norme expérimentale existe depuis 2006 pour limiter cet impact : **Sender Policy Framework** (SPF), _[RFC 4408](http://tools.ietf.org/html/rfc4408)_.

Cette norme n'est autre qu'une entrée DNS qui va permettre de dresser une liste des adresses IP autorisées ou non à envoyer du courriel pour un domaine donné.

De manière plus détaillées, du type TXT (_pour la rétrocompatibilité_) ou SPF, cette entrée se présente sous cette forme (_exemple avec devaproxis.fr_) :
   
    devaproxis.fr.          86400   IN      TXT     "v=spf1 +a +mx ~all"

Un ensemble (_exemple : +mx:192.168.23.12_) comprend une action (_ici, +_), un sélecteur (_ici, mx_) et une valeur facultative (_ici, 192.168.23.12_).

Selon la norme, nous retrouvons 4 actions :
	
  * \+ : autorisé (_pass_)
  * ? : neutre (_neutral_)
  * ~ : suspect (_soft fail_)
  * \- : interdit (_fail_)

Ces actions sont à utiliser avec une liste de sélecteurs. En voici quelques uns :
	
  * a : se réfère aux enregistrements DNS de type A
  * mx : se réfère aux enregistrements DNS de type MX
  * ip4 : se réfère à une adresse IPv4
  * ip6 : idem, pour une adresse IPv6
  * all : désigne tout

La valeur est facultative pour les sélecteurs _a_ et _mx_, auquel cas le domaine courant est sélectionné de manière implicite.

Ce n'est pas clair ? Petite traduction de l'exemple :
	
  * _+a_ : autorise toutes les entrées DNS de type A du domaine devaproxis.fr (_utile pour les serveurs web_)
  * +_mx _: autorise toutes les entrées DNS de type MX du domaine devaproxis.fr (_utile, non ? :)_)
  * _~all_ : n'autorise pas (_soft fail_) les autres adresses IP envoyant du courriel au nom de devaproxis.fr

Vous pouvez, bien entendu, mélanger les sélécteurs à votre guise. Autre exemple :
    
    domaine1.org IN v=spf1 +a +a:domaine2.com +mx +ip4:1.1.1.1 ~ip4:8.4.4.8 -all

Dans ce cas, nous autorisons toutes les entrées DNS de type A des domaines _domaine1.org_ et _domaine2.com_ ainsi que les entrées DNS de type MX et l'adresse IP 1.1.1.1 à envoyer du courriel au nom de _domaine1.org_. Cependant, nous n'autorisons pas _(soft fail_) l'adresse IP 8.4.4.8 et nous rejetons toutes les autres adresses IPs.

Tout comme pour le spam, la norme SPF en action se présente sous la forme d'un marquage dans l'en-tête d'un email, calculé par le serveur à la réception. Ainsi, libre à l'administrateur d'appliquer différentes règles : tout marquer mais laisser passer, rejeter le '_fail_' ou encore rejeter tout ce qui ne passe pas ... Pour exemple, Gmail marque les mails mais ne semble pas filtrer.

Si je n'ai pas été assez (_ou pas du tout ..._) clair ou si vous souhaitez de plus amples informations, visitez [cette page](http://www.openspf.org/SPF_Record_Syntax).
