Date: 2010-10-26 19:01:05
Title: Git : simuler un stash avec un working tree séparé
Category: Tips

Dans certaines situations nous pouvons être amené à devoir modifier des fichiers sans les pousser sur le dépôt Git (_exemple : fichiers de configuration en production_). Ces modifications non commitées sont donc perdues à chaque checkout effectué sur l'arbre de travail.

Une solution simple pour protéger ces fichiers modifiés est l'utilisation de git-stash : pouvoir mettre de côté une pile de modifications pour faire d'autres modifications (pull, merge, checkout ...) sur le working tree puis ensuite remettre ces fichiers en position. Un soucis se présente : la commande stash ne peut pas être utilisée sur un dépôt Git dont le working tree est séparé (voir exemple [ici](http://toroid.org/ams/git-website-howto)). Que faire donc ? Simuler le fonctionnement de stash avec des hooks.

Je présente ici deux méthodes différentes.

### Remplacement de fichiers sans conservation de contexte

Cette méthode est rapide à mettre en place et utile si les fichiers modifiés ne changeront plus : un dossier contient les fichiers d'origine et les remet sur le working tree après le checkout.

Créez un dossier `replaces/` dans le dépôt Git (distant), il contiendra les fichiers d'origine. Créez un fichier `hooks/post-receive` (_et faites un chmod +x dessus)_ :

``` bash
#!/bin/sh

echo "Checkout working tree ..."
git checkout -f

echo "Replacing non commited files ..."
WORKTREE=`git config core.worktree`
for i in $(find replaces -type f); do cp -af $i ${WORKTREE}$(echo $i | cut -d/ -f 2-); done

exit 0
```

git checkout permet de mettre à jour le working tree avec les nouveaux fichiers.

### Remplacement de fichiers avec conservation de contexte

Cette méthode va réellement simuler le fonctionnement de stash : les fichiers modifiés sur le working tree vont être mis de côté avant le checkout puis replacés après.

Créez un dossier `replaces/` dans le dépôt Git (distant), il contiendra les fichiers modifiés lors des réceptions de commits. Créez un fichier `hooks/pre-receive` (_et faites un chmod +x dessus_) :

``` bash
#!/bin/sh

echo "Saving non commited files ..."
WORKTREE=`git config core.worktree`
for i in $( git status --porcelain -uno | awk -F ' ' '{print $2}'  ); do mkdir -p replaces/$(dirname $i); cp -a ${WORKTREE}${i} replaces/$(dirname $i); done

exit 0
```

Ensuite, créez un fichier hooks/post-receive (_avec le droit +x qui va bien_), il reprend le script de la première partie en ajoutant la suppression des fichiers après commit :

``` bash
#!/bin/sh

echo "Checkout working tree ..."
git checkout -f

echo "Replacing non commited files ..."
WORKTREE=`git config core.worktree`
for i in $(find replaces -type f); do cp -af $i ${WORKTREE}$(echo $i | cut -d/ -f 2-) && rm $i; done
# Cleaning folders
for i in $(find replaces -type d | tail -n +2); do rmdir $i; done

exit 0
```

Voilà, les hooks sont en place et seront executés automatiquement lors de vos push sur le dépôt. Merci à [Keruspe](http://twitter.com/Keruspe) pour avoir mis fin à ma prise de tête sur la prise en charge des sous-dossiers.
