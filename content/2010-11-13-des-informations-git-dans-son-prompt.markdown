Date: 2010-11-13 19:59:52
Title: Des informations Git dans son prompt
Category: Tips

N'avez-vous pas remarqué comme il est vite ennuyeux de devoir faire un `git branch` ou un `git status` pour savoir dans quelle branche on était et dans quel état était le dépôt ? Voilà une petite astuce pour ajouter ces deux informations directement dans votre prompt.

Ajoutez ceci à la fin de votre fichier `~/.bashrc` :

``` bash
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function parse_git_status {
  noupdated=`git status --porcelain 2> /dev/null | grep -E "^ (M|D)" | wc -l`
  nocommitted=`git status --porcelain 2> /dev/null | grep -E "^(M|A|D|R|C)" | wc -l`

  if [[ $noupdated -gt 0 ]]; then echo -n "*"; fi
  if [[ $nocommitted -gt 0 ]]; then echo -n "+"; fi
}

RED="\[\033[01;31m\]"
YELLOW="\[\033[01;33m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
NC="\[\033[0m\]"

case $TERM in
    xterm*)
        TITLEBAR='\[\e]0;\u@\h: \w\a\]';
        ;;
    *)
        TITLEBAR="";
        ;;
esac

PS1="${TITLEBAR}$RED\$(date +%H:%M) $GREEN\u@\h $BLUE\w$YELLOW\$(parse_git_branch)\$(parse_git_status) $BLUE\$ $NC"
```

Cette modification ajoute le nom de la branche en cours ainsi qu'un * si des fichiers trackés ont été modifiés mais pas ajoutés et + si des fichiers ont été modifiés mais le commit n'a pas encore été fait.  

Le prompt est inspiré du prompt Gentoo. Quant à la barre des titres, elle est inspirée d'Ubuntu.

![Screenshot](/images/2010/11/Screenshot-55-1.png)

_Enjoy it !_

  * [Liste des couleurs Bash](https://wiki.archlinux.org/index.php/Color_Bash_Prompt#List_of_colors_for_prompt_and_Bash)
  * Source (_en partie_) : [Show Your GIT Branch Name In Your Prompt](http://www.jonmaddox.com/2008/03/13/show-your-git-branch-name-in-your-prompt/)
