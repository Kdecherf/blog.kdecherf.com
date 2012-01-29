---
date: '2009-04-18 23:29:33'
layout: post
slug: svn-creer-un-resume-git-like
status: publish
title: 'SVN : Créer un résumé Git-Like'
wordpress_id: '551'
categories:
- Tips
tags:
- git
- svn
---

Si vous êtes comme moi à aimer connaître le nombre de lignes ajoutées et supprimées depuis telle révision mais que vous êtes sous **SVN** et pas sous **Git** alors cet article est fait pour vous.




Voici un petit script **bash** local qui calcule le nombre de fichiers modifiés ainsi que le nombre d'insertions et de suppressions depuis la révision indiquée ou depuis la première révision de la journée.




Sans plus attendre, voilà le code





[bash]#!/bin/sh

HEAD=`svn info $1 | grep "Révision :" | awk -F ' ' '{print $3}'`
FRE=`svn log $1 | grep \`date +"%Y-%m-%d"\` | tail -n 1 | awk -F ' ' '{print $1}' | sed s/r//`

if [ ! -z $2 ]; then
FRE=$2
fi

ADD=`svn diff -r $FRE $1 | grep -R "^\+" | grep -Rv "^+++" | wc -l`
DEL=`svn diff -r $FRE $1 | grep -R "^\-" | grep -Rv "^---" | wc -l`
FCHG=`svn diff -r $FRE $1 | grep -R "Index:" | wc -l`

echo Since commit $FRE of $HEAD : $ADD insertions, $DEL deletions and $FCHG files changed[/bash]





Ce petit script est vraiment (vraiment) très basique, vous le lancez en indiquant le chemin vers votre copie de travail (à jour bien sûr :)) et vous pouvez indiquer une révision en deuxième argument. Exemple :





[text]kdecherf@bouh ~ $ ./svn-log.sh devafx/trunk 68
Since commit 68 of 71 : 797 insertions, 734 deletions and 21 files changed[/text]





Naturellement, ce script peut être amélioré : ajout de couleurs, optimisation et affichage de plus d'informations. Amusez-vous ;-)



