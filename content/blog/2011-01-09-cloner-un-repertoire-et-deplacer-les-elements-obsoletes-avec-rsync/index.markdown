---
title: "Clôner un répertoire et déplacer les éléments obsolètes avec rsync"
date: 2011-01-09T15:40:30+01:00
tags:
- rsync
---

Depuis le temps que je devais le faire, hier j'ai mis en place ma petite stratégie de sauvegarde avec un script perso et rsync. Je voulais avoir un clône parfait de mes dossiers : ne pas garder les éléments qui ne sont plus dans la source. Et si jamais on supprime un élément par erreur et qu'il est définitivement perdu lors de la sauvegarde ?

La solution la plus simple est de simuler une première sauvegarde avec l'option `--dry-run` (-n) afin d'obtenir la liste des fichiers qui vont être supprimés du dossier de destination puis de les déplacer avant de lancer la sauvegarde. Ainsi, on arrive à un script ressemblant à ça :

``` bash
#!/bin/bash

echo "Generating list of files to be rejected..."
# Préfixe de dossier à retirer lors du nettoyage (utile pour les chemins absolus)
# La chaîne doit être échappée pour passer avec 'sed'
RMPREFIX="\/prefixe\/"
# Le slash de fin est important pour la source, ainsi rsync va copier le contenu du dossier (au lieu du dossier lui-même)
SOURCE="/dir1/"
DEST="/dir2"
REJECTFOLDER="/dirr"
# On va chercher la liste des fichiers et dossiers allant être supprimés
rsync -avn --delete-after $SOURCE $DEST | grep ^deleting | sed s/"^deleting "/""/ | while read line; do
 if [[ -d "$DEST/$line" ]]; then
  echo "Deleting $line..."
  rmdir "$DEST/$line"
 else
  echo "Rejecting $line..."
  FDIR=`dirname "$DEST/$line"`
  if [[ ! -z $RMPREFIX ]]; then
   FDIR=`echo $FDIR | sed s/"$RMPREFIX"/""/`
  fi
  mkdir -p "$REJECTFOLDER/$FDIR"
  mv "$DEST/$line" "$REJECTFOLDER/$FDIR/"
 fi
done
# Ici on peut lancer le vrai rsync
```

Exemple de résultat :

![Screenshot]({attach}Screenshot-113-1.png)
{: .image}

Enjoy it !
