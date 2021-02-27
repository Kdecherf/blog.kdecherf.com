---
title: "Comparatif PHP : Localisation des dates"
date: 2009-02-16T21:00:32+01:00
tags:
- php
---

Nombreux sont les développeurs qui souhaitent afficher une date sur leurs pages avec les jours et mois en français. Actuellement ce n'est pas implémenté dans PHP, tout est retourné en anglais.

Cependant, il existe 2 solutions pour localiser les dates : la **localisation numérique** et le **remplacement de mots**. Nous allons comparer ces 2 solutions.

Les 2 codes présentés ci-dessous sortent le même texte, exemple :

> Mardi 17 Février 2009

### Localisation numérique

_Le but de cette solution est de sortir les valeurs numériques des jours et des mois afin de les utiliser comme index de tableau._

``` php
<?php
$time = time();
$days = array( 'Lundi' , 'Mardi' , 'Mercredi' , 'Jeudi' , 'Vendredi' , 'Samedi' , 'Dimanche' );
$months = array( 'Janvier' , 'Fevrier' , 'Mars' , 'Avril' , 'Mai' , 'Juin' , 'Juillet' , 'Aout' , 'Septembre' , 'Octobre' , 'Novembre' , 'Decembre' );
$txt = $days[date( 'N' , $time ) - 1] . ' ' . date( 'd' , $time ) . ' ' . $months[date( 'm' , $time ) - 1] . ' ' . date( 'Y' , $time );
?>
```

Ainsi avec ce code nous obtenons :
> Exec time : 3.307s for 25 000 operations.  
> Tr / s : 7 559  
> Exec time : 2.711s for 25 000 operations.  
> Tr / s : 9 223  
> Exec time : 3.070s for 25 000 operations.  
> Tr / s : 8 142  
> Exec time : 2.831s for 25 000 operations.  
> Tr / s : 8 830  
> Exec time : 7.432s for 25 000 operations.  
> Tr / s : 3 364  
> Exec time : 2.811s for 25 000 operations.  
> Tr / s : 8 892

### Remplacement de mots

_Le but de cette solution est de sortir la date en anglais et de remplacer des éléments anglais par leur traduction française._


``` php
<?php
$array = array( 'Monday' => 'Lundi' , 'Tuesday' => 'Mardi' , 'Wednesday' => 'Mercredi' , 'Thursday' => 'Jeudi' , 'Friday' => 'Vendredi' , 'Saturday' => 'Samedi' , 'Sunday' => 'Dimanche' , 'January' => 'Janvier' , 'February' => 'Fevrier' , 'March' => 'Mars' , 'April' => 'Avril' , 'May' => 'Mai' , 'June' => 'Juin' , 'July' => 'Juillet' , 'August' => 'Aout' , 'September' => 'Septembre' , 'October' => 'Octobre' , 'November' => 'Novembre' , 'December' => 'Decembre' );
$txt = strtr( date( 'l d F Y' , $time ) , $array );
?>
```

Ainsi avec ce code nous obtenons :
> Exec time : 5.891s for 25 000 operations.  
> Tr / s : 4 244  
> Exec time : 7.988s for 25 000 operations.  
> Tr / s : 3 130  
> Exec time : 2.546s for 25 000 operations.  
> Tr / s : 9 819  
> Exec time : 3.068s for 25 000 operations.  
> Tr / s : 8 148  
> Exec time : 3.089s for 25 000 operations.  
> Tr / s : 8 094  
> Exec time : 4.845s for 25 000 operations.  
> Tr / s : 5 160

### Conclusion

Finalement nous ne voyons pas de grosse différence entre les 2 méthodes même si la première méthode semble plus rapide. Ainsi donc libre à vous d'implémenter la solution qui vous semble la plus simple.
