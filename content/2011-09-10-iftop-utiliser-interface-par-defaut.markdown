Date: 2011-09-10 13:29:47
Title: Iftop : utiliser l'interface par défaut
Category: Tips

Je ne poste pas souvent ces temps-ci, mais en ce début de week-end je vous offre une petite astuce pour _iftop_, l'utilitaire qui permet d'afficher en détail le traffic entrant et sortant d'une interface réseau.

Venant de migrer sur tmux, je me suis réservé une fenêtre pour iftop. Le soucis c'est qu'il faut préciser à chaque fois quelle interface doit utiliser ce dernier au lancement et je ne suis pas tout le temps sur un réseau filaire. Voilà une petite astuce pour contourner ce problème :

``` bash
iftop -i `ip route | grep -E "^default" | awk -F' ' '{print $5}' | sed -n 1p`
```

Cette commande va récupérer l'interface par défaut via la table de routage. S'il y a plusieurs routes par défaut, on prend la première. A noter que je pars du principe que la route par défaut précise toujours une interface et que vous avez installé _ip_, exemple :

    % ip route
    default via 192.168.0.1 dev eth0  proto static

_Enjoy it !_
