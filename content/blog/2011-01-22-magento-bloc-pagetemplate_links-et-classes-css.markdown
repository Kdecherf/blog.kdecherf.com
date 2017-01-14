Date: 2011-01-22 23:25:40
Title: Magento : bloc page/template_links et classes CSS
Category: Blog
Tags: magento

C'est au cours d'une mission sur Magento que j'ai remarqué un fonctionnement plutôt limitant du bloc `page/template_links`. En effet on ne peut pas assigner de classes personnalisées à la balise `li`. Voici la solution (pour les plus fainéants :)).

### Problème

Vous avez surement déjà utilisé un bloc de ce type, il vous permet d'ajouter des liens depuis les fichiers xml de configuration du thème :

``` xml
<block type="page/template_links" name="top.links" as="topLinks">
 <action method="addLink" translate="label title" module="customer">
   <label>My Account</label>
   <url helper="customer/getAccountUrl"/>
   <title>My Account</title>
   <prepare/>
   <urlParams/>
   <position>10</position>
   <liParams>class="myaccount" id="topAccount"</liParams>
 </action>
</block>
```

Ce bloc, si pratique, a une faiblesse. Du moins avec le template par défaut `app/design/frontend/base/default/template/page/template/links.phtml`

``` html+php
<?php $_links = $this->getLinks(); ?>
<?php if(count($_links)>0): ?>
<ul class="links"<?php if($this->getName()): ?> id="<?php echo $this->getName() ?>"<?php endif;?>>
    <?php foreach($_links as $_link): ?>
        <li<?php if($_link->getIsFirst()||$_link->getIsLast()): ?> class="<?php if($_link->getIsFirst()): ?>first<?php endif; ?><?php if($_link->getIsLast()): ?> last<?php endif; ?>"<?php endif; ?> <?php echo $_link->getLiParams() ?>><?php echo $_link->getBeforeText() ?><a href="<?php echo $_link->getUrl() ?>" title="<?php echo $_link->getTitle() ?>" <?php echo $_link->getAParams() ?>><?php echo $_link->getLabel() ?></a><?php echo $_link->getAfterText() ?></li>
    <?php endforeach; ?>
</ul>
<?php endif; ?>
```

On remarquera qu'il n'est pas possible, du moins pour les premiers et derniers éléments de listes, d'avoir un attribut `class` assigné via le paramètre `liParams` du layout (_cf. exemple du début_) car cela fait doublon.


### La solution

La solution consiste à traiter le contenu de la méthode `getLiParams()` afin d'y inclure les classes `first` et/ou `last` en fonction de la position du lien, évitant ainsi de générer un attribut html en double. En mettant le code PHP directement dans le fichier phtml, cela donne :

``` html+php
<?php $_links = $this->getLinks(); ?>
<?php if (count($_links) > 0): ?>
    <ul class="links"<?php if ($this->getName()): ?> id="<?php echo $this->getName() ?>"<?php endif; ?>>
    <?php foreach ($_links as $_link): ?>
    <?php
	    $liparams = $_liparams = $_link->getLiParams();

	    // Is class exists in liparams ?
	    if (preg_match('`class="([^"]*)"`i', $_liparams, $rtn)) {
		$orig = $rtn[0];
		$classes = explode(' ', $rtn[1]);

		if ($_link->getIsFirst())
		    $classes[] = 'first';

		if ($_link->getIsLast())
		    $classes[] = 'last';

		$rplc = implode(' ', $classes);
		$liparams = str_replace($orig, 'class="' . $rplc . '"', $_liparams);
	    } else {
		if ($_link->getIsFirst())
		    $liparams .= ' class="first ';

		if ($_link->getIsLast()) {
		    if (!$_link->getIsFirst())
			$liparams .= ' class="';

		    $liparams .= 'last';
		}

		if ($liparams != $_liparams)
		    $liparams = rtrim($liparams) . '"';
	    }
    ?>
	    <li<?php if($liparams): ?> <?php echo $liparams ?><?php endif; ?>><?php echo $_link->getBeforeText() ?><a href="<?php echo $_link->getUrl() ?>" title="<?php echo $_link->getTitle() ?>" <?php echo $_link->getAParams() ?>><?php echo $_link->getLabel() ?></a><?php echo $_link->getAfterText() ?></li>
    <?php endforeach; ?>
	</ul>	
<?php endif; ?>
```

De manière plus propre, on pourra mettre ce bout de code en tant qu'Helper dans un module perso. L'appel devient donc :

``` html+php
<?php $_links = $this->getLinks(); ?>
<?php if(count($_links)>0): ?>
<ul class="links"<?php if($this->getName()): ?> id="<?php echo $this->getName() ?>"<?php endif;?>>
    <?php foreach($_links as $_link): ?>
	<?php
	// Fix for li classes issue.
	$fixhlp = Mage::helper('mymodule/myhelper');
	$liparams = $fixhlp->liParamsHelper($_link);
	?>

        <li<?php if($liparams): ?> <?php echo $liparams ?><?php endif; ?>><?php echo $_link->getBeforeText() ?><?php if($_link->getLabel()): ?><a href="<?php echo $_link->getUrl() ?>" title="<?php echo $_link->getTitle() ?>" <?php echo $_link->getAParams() ?>><?php echo $_link->getLabel() ?></a><?php endif; ?><?php echo $_link->getAfterText() ?></li>
    <?php endforeach; ?>
</ul>
<?php endif; ?>
```

Enjoy it !
