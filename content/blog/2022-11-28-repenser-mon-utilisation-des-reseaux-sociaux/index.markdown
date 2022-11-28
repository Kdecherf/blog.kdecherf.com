---
title: "Repenser mon utilisation des réseaux sociaux"
date: 2022-11-28T20:36:14+01:00
tags:
- Thoughts
---

Il y a une dizaine d'années j'arrêtais d'aller sur Facebook et je supprimais
l'application de mon téléphone. À l'époque déjà je trouvais que mon utilisation
du réseau avait une tendance à devenir toxique.

En revanche je suis resté actif sur un réseau d'un autre genre : Twitter. J'y
suis depuis 13 ans et je l'utilise quotidiennement à plusieurs fins :
- Faire de la veille, technique comme générale
- Découvrir du contenu qui vient de l'extérieur de mon réseau
- Partager ce que je lis et ce qui m'intéresse[^1]
- Echanger avec d'autres

Cela fait quelques temps que je pense de plus en plus à mon utilisation de
ce réseau.

En premier lieu il y a l'idée que se reposer sur une plateforme privée de ce
type pour "produire du contenu" peut nous rendre vulnérable à une disparition
du contenu ou de la plateforme et peut rendre difficile la migration d'une
communauté vers une autre plateforme (_manque d'interopérabilité ou de
standard, nom d'utilisateur lié à l'adresse de la plateforme_). L'actualité
récente autour de la reprise du réseau par Elon Musk a peut-être accéléré mon
envie de migrer vers un outil qui me permettrait d'être plus indépendant.

À cela s'ajoute un autre aspect, peut-être plus subjectif : mon utilisation que
je fais de ce réseau est probablement devenue néfaste pour moi, à plusieurs
égards. À commencer par le fait que j'ouvre machinalement l'application pour
avoir mon shot de dopamine et de récompense immédiate, à tel point qu'Android
me fait savoir que je l'ouvre entre 50 et 70 fois et j'y passe un peu moins
d'une heure par jour, sans compter l'utilisation des clients web depuis un
ordinateur. Deux notions peuvent accompagner cette dérive addictive : le
syndrome du _Fear of Missing Out_[^2] et le concept d'économie de
l'attention[^3].

![](android-screenshot.jpg)
_Captures d'écran de Android Digital Wellbeing_

Vient ensuite l'anxiété. Une anxiété qui peut venir de la prédominance
d'informations à tendance négative, particulièrement depuis deux ans. Mais une
anxiété qui vient peut-être avant tout de la surcharge informationnelle[^4] :
un excès d'information qui peut devenir nuisible.

Cette image résume une partie de mes pensées sur Twitter :
https://framablog.org/2022/11/18/29098/

Ces constats étant posés, que fais-je maintenant ?

Beaucoup parlent de Mastodon, un réseau social permettant de fédérer des
instances indépendantes entre elles. Cet outil repose sur le concept de
_fediverse_ et est articulé autour de _ActivityPub_, un protocole standardisé
permettant à différents réseaux sociaux de communiquer entre eux. C'est ainsi
qu'un utilisateur Mastodon peut suivre et commenter d'autres utilisateurs sur
des instances Pleroma, PeerTube ou encore PixelFed.

La philosophie portée par ces outils me parait intéressante, rejoignant en
partie l'objectif de départ du web. Cependant je trouve ces outils trop lourds
à maintenir pour un usage mono-utilisateur, sachant que j'aimerais héberger mon
compte sous mon propre nom de domaine. Je vais peut-être me diriger vers une
solution moins _user-friendly_ mais tout de même compatible avec le reste du
_fediverse_, comme microblog.pub.

Pourquoi publier son compte sur son propre domaine ? Principalement pour être
indépendant de la plateforme technique utilisée en dessous, que ça concerne un
site perso, des emails ou un "micro-blog".

Un toot de ploum à ce sujet :

> Each new generation on the web needs to learn that there’s no such thing as a permanent web identity on a commercial web service.
> 
> The only long-term solution to maintain your identity is:
> 1. your own domain name
> 2. Your own website/blog
> 3. Several backups
> 
> Everything else is temporary. Your accounts on myspace, facebook, medium, twitter, google plus, youtube, tiktok, mastodon will one day disappear or become useless.
> 
> You don’t have a "community" on those websites.  Only ephemeral discussions.  
> — https://mamot.fr/@ploum/109364008893158786

L'idée d'être en possession de son site, de son contenu et de son nom de
domaine rejoint les fondamentaux de la communauté IndieWeb[^5]. Parmi ceux-ci,
on y retrouve le concept de POSSE[^6] : _Publish (on your) Own Site, Syndicate
Elsewhere_, où même si vous décidez de publier du contenu sur une instance
Mastodon, Twitter ou un autre réseau social, le contenu originel se trouve
avant tout sur votre site.

Même si le changement d'outil devrait me permettre de conserver cette capacité
de partager des choses, le retrait d'un réseau actif et centralisé comme
Twitter risque de rendre plus difficile la veille et la découverte de contenus
extérieurs à mon réseau. À titre d'exemple, sur 7 800 articles sauvegardés sur
mon compte Wallabag, 2 000 proviennent de tweets soit 25%.

En attendant je vais peut-être réussir à ne plus rager en voyant passer des
threads Twitter, parce que je trouve ce format très inefficace et frustrant.

_See you somewhere on the web._

Quelques citations et quelques liens en vrac pour compléter ce billet :

> At some level, I am relieved that Elon Musk is destroying Twitter. At
> another, I am horrified that one of the main ways that I communicate on the
> Internet is being destroyed  
> — https://xeiaso.net/blog/rip-twitter

> D’abord, je crois profondément que l’on ne convainc plus grand monde sur un
> réseau social comme Twitter. Ce dernier n’est simplement pas designé pour
> cela. Les limites de caractère, la nature des fonctions retweet et j’aime,
> l’algorithme, etc. Tout est fait pour viraliser le clash plutôt que valoriser
> l’échange constructif et apaisé. Ce n’est pas prêt de s’arranger, et ça peut
> empirer.  
> — https://louisderrac.com/2022/10/31/au-revoir-twitter/

> Twitter. Unquestionably designed to maximize usage, with all of the cognitive
> tricks some of the most clever scientists have ever engineered. I could write
> a whole book about Twitter. The tl;dr is that I used Twitter for all of the
> above (News, Work, Stock) as well as my primary means of interacting with
> other people/”friends.” I didn’t often consciously think about how much it
> messed me up to go from interacting with a large number of people every day
> (working at Microsoft) to engaging with almost no one in person except [my
> ex] and the kids. Over seven years, there were days at Telerik, Google, and
> Microsoft where I didn’t utter a word for nine workday hours at a time.
> That’s plainly not healthy, and Twitter was one crutch I tried to use to
> mitigate that.  
> — https://textslashplain.com/2022/11/17/thoughts-on-twitter/

> The original internet was set up decentralized, with the goal to be resilient
> to failing parts and to attacks. A lot of this property has been undone by
> re-centralisation: if AWS has an outage, half the internet goes down. When
> Twitter is run into the ground by some Billionaire Chaos Monkey, the whole
> world sees it's journalist and government communication break down. A
> (lifted) ban on Twitter has actual effect on democracy and society  
> — https://berk.es/2022/11/08/fediverse-inefficiencies/

- [The Fediverse is Inefficient (but that's a good trade-off)](https://berk.es/2022/11/08/fediverse-inefficiencies/)
- [Why I Still Use RSS](https://atthis.link/blog/2021/rss.html)
- [Pour lutter contre les GAFA, Framasoft veut aller plus loin dans la décentralisation du Web](https://www.lemonde.fr/pixels/article/2019/12/27/chez-framasoft-des-chatons-pour-sortir-des-gafa_6024230_4408996.html)
- [Declaration of Digital Independence](https://larrysanger.org/2019/06/declaration-of-digital-independence/)
- [Re-decentralizing the Web, for good this time](https://ruben.verborgh.org/articles/redecentralizing-the-web/)
- [We Should Replace Facebook With Personal Websites](https://www.vice.com/en/article/vbanny/we-should-replace-facebook-with-personal-websites)
- [It's time to take back your data from Google and Facebook's server farms](https://www.theguardian.com/commentisfree/2018/dec/12/its-time-to-take-back-your-data-from-google-and-facebooks-server-farms?CMP=share_btn_tw)
- [I quit Instagram and Facebook and it made me a lot happier — and that’s a big problem for social media companies](https://www.cnbc.com/2018/12/01/social-media-detox-christina-farr-quits-instagram-facebook.html)
- [Nettoyer son compte Twitter](https://www.simounet.net/nettoyer-son-compte-twitter/)

Les différents outils du _fediverse_ cités dans l'article :
- https://joinmastodon.org/
- https://pleroma.social/
- https://pixelfed.org/
- https://joinpeertube.org/
- https://microblog.pub/

[^1]: https://kdecherf.com/blog/2018/04/29/sharing-links/
[^2]: https://fr.wikipedia.org/wiki/Syndrome_FOMO
[^3]: https://fr.wikipedia.org/wiki/%C3%89conomie_de_l%27attention
[^4]: https://fr.wikipedia.org/wiki/Surcharge_informationnelle
[^5]: https://indieweb.org/IndieWeb
[^6]: https://indieweb.org/POSSE
