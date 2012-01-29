---
date: '2010-01-11 14:11:32'
layout: post
slug: magento-encadrer-un-bloc-via-les-layouts
status: publish
title: 'Magento : encadrer un bloc via les layouts'
wordpress_id: '1236'
categories:
- Tips
tags:
- Magento
---

**Magento**, mastodonte de l'_e-Commerce_, se veut être (_sans aucun doute_) la plateforme la moins bien documentée officiellement. Travaillant actuellement dessus, je ferai part ici de mes quelques astuces qui peuvent vous aider ...




[![](http://blog.kdecherf.com/wp-content/uploads/2010/01/magento_logo.gif)](http://blog.kdecherf.com/wp-content/uploads/2010/01/magento_logo.gif)




Ma première astuce concerne les blocs et les superbes layouts XML. Considérons le bloc statique _left_anchor_ déclaré dans le layout comme suit :


[xml]
      <block type="cms/block" name="left_anchor" as="left_anchor">
       <action method="setBlockId"> <block_id>left_anchor </block_id>
      </action>[/xml]


Au niveau design, vous devez impérativement encadrer le contenu par un _<div id='LeftAnchor'></div>_.




Deux possibilités 'rapides' s'offrent à vous : ajouter le conteneur directement dans le contenu du bloc statique ou encore encadrer le _$this->getChildHtml('left_anchor')_ dans le template HTML si vous le pouvez.




Si vous ne pouvez ou ne voulez pas utiliser ces options, il vous reste une troisième alternative : le layout XML. On a à notre disposition un template _wrapper.phtml_ et un type de bloc associé qui nous permet d'encadrer tout et n'importe quoi ... Ainsi le layout donne :


[xml]<block type="core/template" name="leftanchor" as="leftanchor" template="page/html/wrapper.phtml">
  <block type="cms/block" name="left_anchor" as="left_anchor">
      <action method="setBlockId"><block_id>left_anchor</block_id></action>
  </block>
  <action method="setId"><id>LeftAnchor</id></action>
</block>[/xml]






Concrètement, l'action _setId_ permet de déclarer l'id de la balise. De la même manière, vous avez les actions _setTag_ si vous souhaitez utiliser autre chose que des _div_s et _setParams_ pour ajouter des paramètres HTML personnalisés (_comme une classe CSS, par exemple_).



