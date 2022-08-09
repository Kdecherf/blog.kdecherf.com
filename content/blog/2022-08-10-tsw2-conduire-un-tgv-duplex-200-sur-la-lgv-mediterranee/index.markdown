---
title: "TSW2 : Conduire un TGV Duplex 200 sur la LGV Méditerranée"
date: 2022-08-10T19:35:22+02:00
tags:
- TSW2
---

Au détour des offres gratuites hebdomadaires sur l'Epic Store je me suis
découvert voilà maintenant quelques mois une nouvelle passion pour… la conduite
de trains avec _Train Sim World 2_.

Je fais ce billet comme anti-sèche pour la conduite du TGV Duplex 200 sur la
ligne Marseille - Avignon avec l'extension _LGV Méditerranée: Marseille -
Avignon Route Add-On_.

![Train Sim World 2: LGV Méditerranée](tsw2-header-lgv.jpg)

## Commandes au clavier

| Opérations                             |     |                |
| -                                      | :-: | :-:            |
| Interrupteur principal                 |     | `Ctrl+W`       |
| Activer/désactiver KVB, TVM, Crocodile |     | `Ctrl+Enter`   |
| Activer/désactiver VACMA               |     | `Shift+Enter`  |
| Activer/désactiver disjoncteur         |     | `Ctrl+P`       |
| Réarmer disjoncteur                    |     | `Ctrl+Shift+P` |
| Pantographe (*lever / baisser*)        | `P` | `Shift+P`      |
| Action porte (*gauche / droite*)       | `Y` | `U`            |

| Conduite                           |          |                |
| -                                  | :-:      | :-:            |
| Mode de conduite (+ / -)           | `Ctrl+R` | `Ctrl+Shift+R` |
| Sélecteur de vitesse (*+ / -*)     | `R`      | `F`            |
| Inverseur (*+ / -*)                | `Z`      | `S`            |
| Manipulateur de traction (*+ / -*) | `Q`      | `D`            |
| Frein (*desserage / serrage*)      | `M`      | `%`            |
| Frein d'urgence                    |          | `Backslash`    |
| Ton (*bas / haut*)                 | `Space`  | `N`            |
| Alarme                             |          | `B`            |

| Eclairage                                     |          |                |
| -                                             | :-:      | :-:            |
| Luminosité des phares                         |          | `H`            |
| Lumière (*cabine / pupitre*)                  | `L`      | `Ctrl+L`       |
| Eclairage des instruments                     |          | `I`            |
| Intensité éclairage des instruments (*+ / -*) | `Ctrl+I` | `Ctrl+Shift+I` |
| Eclairage couloirs                            |          | `K`            |
| Réglage essui-glace (*+ / -*)                 | `V`      | `Shift+V`      |
| Sablage, annuler                              | `X`      | `Shift+X`      |

| Divers          |     |            |
| -               | :-: | :-:        |
| Capture d'écran |     | `Ctrl+F12` |


Certaines commandes ne semblent pas disponibles au clavier, parmi lesquelles :

- Annuler le maintien de service
- Sélectionner le mode d'alimentation de la ligne
- Maintien du frein
- Neutre frein

## Procédures

### Démarrage

```
- Appuyer sur le bouton Annuler le maintien de service
- Activer l'interrupteur principal (Ctrl+W)
- Sélectionner le mode d'alimentation correspondant à la ligne
- Lever le pantographe (P)
- Activer le disjoncteur (Ctrl+P)
- Armer le disjoncteur (Ctrl+Shift+P)

- Activer le maintien du frein
- Presser le frein d'urgence (Retour arrière)
- Activer le neutre frein
- Relâcher le frein d'urgence (Retour arrière)
- Désactiver le neutre frein
- Desserer le frein jusqu'à 5 bars (M)
- Serrer le frein jusqu'à 4 bars (%)
- Positionner l'inverseur sur marche avant (Z)
- Sélectionner le mode de conduite manuelle ou vitesse sélectionnée (Ctrl+R)
- Désactiver le maintien du frein
- Desserer le frein (M)
- Appliquer une traction (Q)
```

### Changement d'alimentation

```
- Positionner le manipulateur de traction sur Off (D)
- Ouvrir puis fermer le disjoncteur (Ctrl+P)
- Baisser le pantographe (Shift+P)
- Sélectionner le mode d'alimentation souhaité
- Au signal REV, lever le pantographe (P)
- Au signal embarqué panto, réarmer le disjoncteur (Ctrl+Shift+P)
- Appliquer une traction (Q)
```

### Récupération d'un freinage d'urgence

```
- Annuler l'alarme active (A)
- Positionner le manipulateur de traction sur Off (D)
- Positionner l'inverseur sur Neutre (S)
- Réarmer le disjoncteur (Ctrl+Shift+P)
- Positionner l'inverseur sur Marche avant (Z)
- Appliquer une légère traction (Q)
- Relâcher le frein (M)
```

## Parcours

L'extension permet de rouler sur la ligne LGV entre les gares
Marseille-St-Charles et Avignon TGV, avec un arrêt possible à la gare de
Aix-en-Provence TGV.

Au départ de la gare de Marseille-St-Charles les limitations de vitesse ne sont
pas signalées, au delà des restrictions du système KVB. La vitesse limite passe
de 30 à 60 km/h aux alentours du PK 860.7 lorsque vous êtes en double-rames, à
110 au PK 860 puis à 140 au PK 858.7. A l'entrée de la ligne 752000 et du
changement d'alimentation, TVM-430 prend le relai pour afficher les limitations
en cabine.

Références :

- [TSW2 LGV Méditerranée Driver Manual (EN)](https://media.dovetailgames.com/Train%20Sim%20World%202%20LGV%20M%C3%A9diterran%C3%A9e%20Driver%27s%20Manual%20EN.pdf)
- [Max speed on OpenRailwayMap](https://www.openrailwaymap.org/?style=maxspeed&lat=43.33182710828102&lon=5.3768205642700195&zoom=14)
- [Carto GRAOU](https://carto.graou.info/43.33082/5.3791/12.85105/0/0)
