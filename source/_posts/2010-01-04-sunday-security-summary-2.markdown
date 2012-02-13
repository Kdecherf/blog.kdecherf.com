---
date: '2010-01-04 02:11:41'
layout: post
title: 'Sunday Security Summary #2'
categories: [Unclassified]
comments: true
---

Tout d'abord, je vous souhaite une bonne année 2010 et tout ce qui va avec :)  
Me revoilà pour le 2ème _**3S**_ avec, cette semaine, un _patch week_ massivement orienté **Drupal**. **Kaspersky**, **IIS**, **Joomla** et **MySQL** l'accompagnent.

{% img center /images/2009/12/3S.png '3S' '3S' %}

**Failles logicielles**
	
  * [**CVE-2009-4484**](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4484) : Buffer overflow dans **MySQL 5.0.51a** pour Linux.
  * [**CVE-2009-4452**](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4452) : Gain de privilège via une injection de librairie sur **Kaspersky Anti-Virus 5.0** (5.0.712), **Antivirus Personal 5.0.x**, **Anti-Virus 6.0** (6.0.3.837), **7** (7.0.1.325), **2009** (8.0.0.x), **2010** (9.0.0.463), **Internet Security 7** (7.0.1.325), **2009** (8.0.0.x) et **2010** (9.0.0.463).
  * [**CVE-2009-4444**](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4444) et [**CVE-2009-4445**](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4445) : Création de fichiers sans accès et détournement de vérification sur **IIS 5** et **6** (_et versions précédentes pour la création_) combinés avec des applications tierces.
  * **[CVE-2009-4457](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4457)** : Vulnérabilités diverses (impacts inconnus) sur le module **Vsftpd** (_avant 1.3b_) pour **Webmin**.

**Failles web**
	
  * **[CVE-2009-4475](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4475)** : Injection SQL dans le module **Joomlub** (*com_joomlub*) pour **Joomla!**
  * **[CVE-2009-4459](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4459)** : Injection XSS via des données UTF-7 pouvant amener à l'exécution de scripts tiers (_sous Internet Explorer 7 et 8_) sur **Redmine 0.8.7.**
  * **[CVE-2009-4429](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4429) **: Injection XSS dans le module **Sections** _5.x avant 5.13 et 6.x avant 6.13_ pour **Drupal.**
  * **[CVE-2009-4513](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4513)** : Injection XSS dans le module **Workflow** _5.x avant 5.x-2.4 et 6.x avant 6.x-1.2_ pour **Drupal**.
  * **[CVE-2009-4514](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4514)** : Injection XSS dans le module **OpenSocial Shindig-Integrator** _5.x and 6.x avant 6.x-2.1_ pour **Drupal**.
  * **[CVE-2009-4515](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4515)** : Faille inconnue donnant accès à des données sensibles dans le module **Storm** _6.x avant 6.x-1.25_ pour **Drupal**.
  * **[CVE-2009-4517](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4517)** et **[CVE-2009-4534](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4534)** : Faille CSRF et redirection ouverte dans le module **FAQ Ask** _5.x et 6.x avant 6.x-2.0_ pour **Drupal**.
  * **[CVE-2009-4518](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4518)** : Injection XSS dans le module **Insert Node** _5.x avant 5.x-1.2_ pour **Drupal**.
  * **[CVE-2009-4520](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4520)** : Accès à des données sensibles via le module **CCK Comment Reference** _5.x avant 5.x-1.2 et 6.x avant 6.x-1.3_ pour **Drupal**.
  * **[CVE-2009-4524](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4524)** : Injection XSS dans le module **RealName** _6.x-1.x avant 6.x-1.3_ pour **Drupal**.
  * **[CVE-2009-4527](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4527)** : Gain de privilège par attaque de proximité dans le module **Shibboleth** _5.x avant 5.x-3.4 et 6.x avant 6.x-3.2_ pour **Drupal**.
  * **[CVE-2009-4528](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4528)** : Accès non autorisé au vocabulaire via le module **Organic Groups (OG) Vocabulary** _6.x avant 6.x-1.0_ pour **Drupal**.
  * **[CVE-2009-4525](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4525)** et **[CVE-2009-4526](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4526)** : Accès à des données sensibles via le module **Print** _5.x avant 5.x-4.9 et 6.x avant 6.x-1.9_ pour **Drupal**.
  * **[CVE-2009-4532](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4532)** et **[CVE-2009-4533](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4533)** : Injection XSS et accès à des données sensibles via le module **Webform** _5.x avant 5.x-2.8 et 6.x avant 6.x-2.8_ pour **Drupal**.

Bon _patching_ et à la semaine prochaine !
