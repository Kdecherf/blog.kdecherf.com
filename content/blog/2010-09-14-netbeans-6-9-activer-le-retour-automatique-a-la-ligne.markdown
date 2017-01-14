Date: 2010-09-14 11:00:42
Title: NetBeans 6.9 : activer le retour automatique à la ligne
Category: Blog
Tags: java, netbeans
Slug: netbeans-6-9-activer-le-retour-automatique-a-la-ligne

S'il y a bien quelque chose qui peut vite devenir frustrant sous NetBeans, c'est bien la ligne à ralonge qui oblige à faire du scroll horizontal. Fonctionnalité demandée depuis plus de 2 ans, l'équipe peine à rendre disponible le retour automatique à la ligne sur ce célèbre IDE. Cependant, il existe un paramètre permettant de l'activer (_testé et approuvé sur la version 6.9_).

Bien que [présente dans la _nightly build_](http://blog.robbychen.com/2010/04/26/enable-line-wrap-option-in-netbeans-nightly/) cette fonctionnalité n'a toujours pas été activée par défaut dans la version finale de NetBeans 6.9, on est donc obligé de toucher à un petit fichier de configuration avant de pouvoir jouer avec les options de l'éditeur.

Editez le fichier `netbeans.conf` qui se trouve dans le dossier `etc/` de votre installation NetBeans, ajoutez le paramètre suivant dans la variable `netbeans_default_options` :
     
    -J-Dorg.netbeans.editor.linewrap=true

Redémarrez l'éditeur puis rendez-vous dans `Tools > Options > Editor > Formatting`: vous pouvez désormais activer l'option _Line Wrap_ à votre guise.

_Note : cette fonctionnalité ne semble pas activée par défaut car elle pourrait causer des dysfonctionnements dans certains cas._

_Enjoy it !_
