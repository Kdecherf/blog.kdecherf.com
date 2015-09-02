Date: 2010-01-10 23:56:52
Title: CentOS : installer Htop simplement
Category: Tips
Tags: centos

Distribution axée sur des dépôts stables, CentOS n'aime pas trop les dépôts d'applis en développement. C'est donc normal qu'un _yum search htop_ nous retourne un vilain _Match not found_.

![htop](/images/2010/01/htop.png)

La solution ultime réside dans l'installation du paquet _rpmforge_ qui va s'occuper de rajouter des dépôts de développement. Si vous êtes paranoïaque quant à la tenue d'une base RPM viable et que vous ne voulez que le paquet htop, voici une méthode plus simple :

Ajoutez le fichier _/etc/yum.repos.d/CentOS-Dag.repo_

``` ini
[dag]
name=Dag RPM Repository for Red Hat Enterprise Linux

baseurl=http://apt.sw.be/redhat/el$releasever/en/$basearch/dag
gpgcheck=1
gpgkey=http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
enabled=1
includepkgs=htop*
```

Sauvegardez et revenez sur votre terminal. Lancez un _yum install htop_ et acceptez la clé publique. Le tour est joué et aucun autre paquet ne sera impacté par l'ajout de ce dépôt :)  
Si vous souhaitez installer d'autres paquets appartenant au dépôt Dag, ajoutez-les à la ligne _includepkgs_.
