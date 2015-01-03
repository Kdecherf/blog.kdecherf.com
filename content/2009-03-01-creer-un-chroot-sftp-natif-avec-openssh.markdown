Date: 2009-03-01 00:19:06
Title: Créer un Chroot SFTP natif avec OpenSSH
Category: Tips
Tags: openssh,sftp

Pour des raisons de sécurité, il est souvent nécessaire d'appliquer des règles de chroot (aussi nommé _jail_ dans le monde \*BSD) afin de parquer un utilisateur dans une zone donnée. Par défaut, pour faire un chroot sur SSH il faut patcher OpenSSH puis installer des binaires sur chaque espace. C'est une méthode très longue et souvent ennuyeuse.

Cependant depuis quelques versions, OpenSSH intègre nativement l'option _ChrootDirectory_. Comme son nom l'indique, c'est pour créer un environnement parqué pour les utilisateurs. Malheureusement cette méthode ne s'applique que pour le serveur interne SFTP. Méthode et explication.

Note : cette solution n'est valable que pour **OpenSSH 4.9** et supérieur.

### Mise en place

La mise en place du chroot est très rapide.

Quelques lignes à modifier dans */etc/ssh/sshd_config*

``` bash
Subsystem       sftp    internal-sftp

Match Group ftpusers
         ChrootDirectory /home/%u
         ForceCommand internal-sftp
         AllowTCPForwarding no
         X11Forwarding no
```

Pour expliquer brièvement ces lignes, nous activons le chroot sur le schéma de répertoire _/home/username_ pour tous les utilisateurs du groupe _ftpusers_ et nous interdisons, par mesure de sécurité, le forward X et tunnel TCP.

A noter que nous devons bien préciser d'utiliser **le serveur sftp interne à OpenSSH** ! Rechargez la configuration OpenSSH et nous pouvons passer à la dernière étape : _gestion des droits_.

### Gestion des droits

**Un répertoire utilisateur (racine chroot) doit impérativement être contrôlé (owner:group) par root !** Et nous devons appliquer les droits o+rx pour permettre à l'utilisateur de lister son répertoire racine.

Exemple : nous avons le compte _john_ chrooté dans _/home/john_ (ce répertoire est naturellement le _homedir_ de _john_). _john_ appartient à son groupe principal _john_ et appartient également au groupe _sftpusers_.

Le répertoire doit avoir l'état suivant :

> drwxr-xr-x 2 root   root   4096 Feb 28 23:56 john

Ceci fait, l'utilisateur peut accéder à son répertoire via SFTP sans pouvoir lister les répertoires parents.

Seul hic à ce stade : il ne peut pas créer directement de répertoire dans _/home/john_.

Deux solutions : donner un accès 777 au répertoire mais cela reste dangereux ou alors créer les répertoires au besoin du client sachant que les répertoires enfants n'ont pas besoin d'appartenir à root.

Voici un exemple :
> total 8  
> drwxr-x--- 2 john john 4096 Mar  1 00:00 bar  
> drwxr-x--- 2 john john 4096 Mar  1 00:00 foo  

Ainsi, l'utilisateur _john_ pourra librement **lire et ecrire **dans les répertoires _foo_ et _bar_ sans que les autres ne puissent lire le contenu et sans qu'il ne puisse monter au dela de son _homedir_.

### Piqure de rappel

Vous souhaitez ajouter l'utilisateur _titi _(_oui ... je suis en manque d'imagination ce soir_) à votre superbe système de prison SFTP.
	
  * Ajoutez l'utilisateur _titi_ comme vous avez l'habitude de faire. Répertoire personnel : _/home/titi_
  * Ajoutez l'utilisateur au groupe _ftpusers _(_à créer si cela n'est pas déjà fait_)
  * Changez le propriétaire du répertoire _/home/titi_ en _root:_ (owner + group) puis ajoutez les droits en lecture/execution (o+rx ou 755) pour tout le monde (_ndlr : vu que personne ne peut accéder via SSH, ce n'est pas vraiment génant_)
  * Ajoutez les répertoires demandés par l'utilisateur puis pensez à changer le propriétaire de ceux-ci en _titi:_ (owner + group) et de supprimer les droits pour les autres (o-rx ou 750) sur ces répertoires
  * ET voilà ! L'utilisateur est enfermé dans sa prison :)

Une note très importante cependant à propos de cette méthode : **ce paramètrage n'est valable que pour SFTP et supprime aux utilisateurs du groupe _ftpusers _la possibilité d'utiliser SSH.**
