---
title: "Récupérer un article depuis le navigateur avec wallabagger"
date: 2023-08-02T22:48:29+02:00
tags:
- wallabag
---

An english version of this post is available [here]({{< ref "/blog/2023-08-02-fetch-content-from-browser-on-demand-with-wallabagger/index.markdown" >}}).

[Wallabagger][1] est une extension de navigateur permettant de sauvegarder des
pages sur votre compte wallabag.

Depuis la version [v1.14.0][2], cette extension est capable de récupérer le contenu
de la page à sauvegarder depuis le navigateur, ce qui évite au serveur wallabag
de le récupérer de lui-même. Cela permet de contourner certaines limitations
comme un rendu dynamique ou un _paywall_.

Jusqu'à il y a peu je maintenais une intégration personnalisée sur mon serveur
wallabag pour faire la même chose avec l'extension WebScrapBook. Mais suite à
des changements majeurs importants j'ai abandonné l'idée de continuer à la
maintenir. J'ai alors décidé de ré-essayer la nouvelle option de wallabagger.

La fonctionnalité fait le boulot, mais maintenir une liste de domaines
spécifiques pour la récupération de contenu me semblait assez peu pratique.

La version [v1.16.0][3] a ajouté une option permettant de récupérer le contenu
depuis le navigateur **par défaut**, permettant ainsi de se passer de la liste
de domaines. Cette fonctionnalité aussi comporte une certaine ridigité, puisque
c'est soit l'un soit l'autre.

Comment pourrais-je choisir facilement d'enregistrer un article en passant le
contenu depuis le navigateur ou pas ? Il y a quelques semaines j'ai décidé de
mettre les mains dans le code de l'extension. Pendant mon exploration quelque
chose a attiré mon attention dans le manifeste.

Il s'avère que deux raccourcis clavier sont définis par l'extension :

![Capture d'écran de la gestion des raccourcis Firefox pour wallabagger](firefox-shortcuts.png)

Comprendre la différence entre les deux actions m'a permis de trouver une
solution simple à mon problème.

En considérant que l'option "_Récupérer le contenu depuis le navigateur pour
tous les sites_" est activée :

* "_Activer le bouton de la barre d'outils_" permet de sauvegarder une page en
  récupérant son contenu depuis le navigateur
* "_Enregistrer la page…sans ouvrir la popup_" en revanche va uniquement
  envoyer le lien au serveur wallabag, le laissant récupérer le contenu

En clair, utilisez `Alt+W` si vous souhaitez sauvegarder une page en prenant le
contenu depuis le navigateur ou `Alt+Shift+W` si vous voulez que le serveur le
récupère pour vous.

Pour changer ces raccourcis sur Firefox, suivez [ces instructions][4]. Chrome
et autres dérivés doivent probablement avoir un mécanisme similaire.

_Enjoy_

[1]: https://wallabag.github.io/wallabagger/
[2]: https://github.com/wallabag/wallabagger/releases/tag/v1.14.0
[3]: https://github.com/wallabag/wallabagger/releases/tag/v1.16.0
[4]: https://support.mozilla.org/fr/kb/gerer-raccourcis-extensions-firefox
[^2]: [wallabag vs the web in 2022: the poor's man solution]({{< ref "/blog/2022-03-21-wallabag-vs-the-web-in-2022-the-poors-man-solution/index.markdown" >}})
