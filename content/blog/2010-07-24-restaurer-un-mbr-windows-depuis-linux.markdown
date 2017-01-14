Date: 2010-07-24 15:16:07
Title: Restaurer un MBR Windows depuis Linux
Category: Blog
Tags: windows, linux

Voilà maintenant 3 mois que je n'avais pas posté sur mon blog, je continue sur la lignée du dernier billet en vous proposant une nouvelle astuce tirée par les cheveux (_mais plus simple quand même_). Celle-ci permet de restaurer la zone d'amorçage (_Master Boot Record_) utilisée par Windows ... depuis Linux.

Petit rappel du contexte : vous avez Grub et vous souhaitez le supprimer et retrouver le MBR de Windows. A l'époque de Windows XP, il suffisait de démarrer le CD d'installation en mode "Console de récupération" puis de taper _fixmbr_. Pour Windows Vista et Windows 7, un système de réparation système est disponible sur le CD. Mon problème ? Aucun CD fonctionnel sous la main, il ne me reste donc que mon arme ultime : _Backtrack_.

Je fouille un petit peu sur la toile et je tombe sur le projet [MS-Sys](http://ms-sys.sourceforge.net/). On télécharge l'utilitaire, on le compile puis on l'utilise ... tout simplement :

    ms-sys -7 /dev/sda

Cette commande permet d'installer le MBR Windows 7 sur le disque `sda`.

Cet utilitaire permet d'effectuer d'autres opérations ou d'installer le MBR d'une autre version Windows, n'hésitez pas à lire le manuel :)
