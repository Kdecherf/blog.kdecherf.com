Date: 2009-12-01 16:35:03
Title: Hébergeurs : bloquer l'accès à certaines fonctions PHP
Category: Tips

Si *safe_mode* est efficace, il n'en est pas moins trop efficace au point d'empêcher le bon fonctionnement d'un certain nombre de sites ...

Si vous souhaitez bloquer seulement quelques fonctions (*safe_mode* ou pas), vous avez à votre disposition la directive *[disable_functions](http://www.php.net/manual/en/ini.core.php#ini.disable-functions)* à mettre dans le fichier **php.ini**.

``` ini
disable_functions=mail,fopen,exec
```

A noter que cette astuce est très efficace avec des solutions comme SuPHP permettant d'avoir un php.ini séparé par site.
