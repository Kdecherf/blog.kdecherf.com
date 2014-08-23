---
date: '2010-01-29 00:49:32'
layout: post
title: 'Magento : ajouter un préfixe aux URLs auto-générées'
categories: [Tips]
comments: true
---

Ah Magento et ses joies ... ou pas. Avouez que les URLs auto-générées du style _/category.html_ ou _/product.html_ c'est frustrant si on veut une boutique un tant soit peu "hiérarchisée".

Dans mon exemple, je dois ajouter collection/ devant les noms de catégories et de produits (_exemples : collection/femme, collection/femme/vestes, collection/produit/produit1 ..._). Première solution : modification à la main ... Oubliez, les URLs sont recalculées à chaque vidage du cache. L'unique solution (_à défaut d'avoir un paramètre dans le config.xml_) reste un petit _hack_ dans le core de Magento. Oui, cela fait peur à première vue mais le résultat tient sur 2 lignes.

Le fichier à modifier est `app/code/core/Mage/Catalog/Model/Url.php`

Remplacez, _ligne 551_

``` php
<?php
// ...
return $this->getUnusedPath($category->getStoreId(), $prefix . $parentPath . $urlKey . $categoryUrlSuffix,
```

Par

``` php
<?php
// ...
$prefix = ( $category->getParentId() == x ) ? 'votreprefixe/' : '' ;
return $this->getUnusedPath($category->getStoreId(), $prefix . $parentPath . $urlKey . $categoryUrlSuffix,
```

Remplacez 'x' par l'id de votre catégorie racine et 'votreprefixe' par ... votre préfixe.

Cela ne gère que les URLs de catégories et produits associés [aux catégories]. Pour les produits seuls, veuillez modifier la ligne 577 par :

``` php
<?php
// ...
return $this->getUnusedPath($category->getStoreId(), 'votreprefixeproduit/' . $urlKey . $productUrlSuffix,
```

__*** ATTENTION ***__, il est très important de garder à l'esprit que ces modifications sont susceptibles d'être perdues lors d'une mise à jour de votre installation.

Il est évident que le mieux pour faire ceci serait que le Core intègre une directive de configuration permettant d'assigner des préfixes (_au même titre que les suffixes et extensions_) mais bon, on fait avec ce que l'on a. _Enjoy it !_
