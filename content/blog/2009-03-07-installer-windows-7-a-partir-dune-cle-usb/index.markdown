Date: 2009-03-07 01:44:57
Title: Installer Windows 7 à partir d'une clé USB
Category: Blog
Tags: windows

Windows 7 rime avec netbook. Si si, le monsieur il l'a dit ! Par contre, lecteur DVD rime moins avec netbook. Pas de panique ! Outre la solution de boot par le réseau (PXE) vous pouvez également installer Windows 7 depuis une clé USB. Et même que c'est simple :)

Explications par le [TechNet Magazine](http://technet.microsoft.com/en-us/magazine/dd535816.aspx) :
	
  * Commencez par télécharger et installer [DiskPart Utility](http://www.microsoft.com/downloads/details.aspx?FamilyID=0FD9788A-5D64-4F57-949F-EF62DE7AB1AE) (normalement, il est déjà installé)
  * Lancez-le (tapez " diskpart " dans le menu démarrer)
  * Obtenez la liste des disques disponibles avec **list disk**
  * Sélectionnez votre clé USB avec **select disk _x_** (où _x_ est le numéro de disque)
  * Executez **clean**, puis **create partition primary** puis **active** pour nettoyer, créer et activer la partition principale
  * Formatez la partition avec **format fs=fat32 quick**
  * Tapez **assign** pour assigner une lettre (ça sera utile pour la suite ;) )
  * Copiez tout bêtement le contenu du DVD sur la clé USB (un glisser/déposer suffit)
  * Bootez votre netbook sur la clé USB et _enjoy it_ !

Voilà vous pouvez maintenant déployer Windows 7 sur vos petits monstres :)

Merci à _Matthew Graven_.
