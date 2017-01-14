Title: How to avoid infinite recursion with mod_fastcgi and PHP-FPM without modifying .htaccess
Date: 2012-11-09 15:46
Category: Blog
Tags: apache, php
Slug: how-to-avoid-infinite-recursion-with-mod-fastcgi-and-php-fpm-without-modifying-htaccess

Do you know this error?
``` text
the Request exceeded the limit of 10 internal redirects due to probable configuration error. Use 'LimitInternalRecursion' to increase the limit if necessary
```

It’s really frustrating since the usual fix is to add a `RewriteCond` rule in the .htaccess[ref]_«Making mod\_fastcgi work with mod\_rewrite»_ [http://blog.grahampoulter.com/2012/02/maximum-wordpress-performance-on-ec2.html](http://blog.grahampoulter.com/2012/02/maximum-wordpress-performance-on-ec2.html) [/ref]. However, it's not feasible when you're a hosting platform.

My goal was to add this rule without asking the user to do it himself. The solution was to add a RewriteRule server-wide and force inheritance which is not set by default.

``` text
<VirtualHost ...>
   # Your settings
   <Directory /your/directory>
      # Your settings
      <IfModule mod_rewrite.c>
         RewriteEngine on
         RewriteOptions InheritBefore
         RewriteBase /
         RewriteCond %{REQUEST_URI} ^/your-cgi-bin-fcgi-path(.*)
         RewriteRule . - [L]
      </IfModule>
   </Directory>
</VirtualHost>
```

This rule will simply do nothing and block all other rules (_with option `[L]`_) for this path.

> With `RewriteOptions Inherit`, Apache will inherit server-wide rules and execute them only after the rules of `.htaccess`. With `InheritBefore` it executes them before.

_**Note**: `InheritBefore` is available in Apache [since 2.3.10](http://httpd.apache.org/docs/current/fr/mod/mod_rewrite.html#rewriteoptions)_

_Enjoy!_
