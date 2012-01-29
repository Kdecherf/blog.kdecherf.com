---
date: '2010-01-18 23:59:39'
layout: post
slug: sunday-security-summary-4
status: publish
title: 'Sunday Security Summary #4'
wordpress_id: '1274'
categories:
- Unclassified
---

Petit point habituel de la semaine passée en matière de sécurité, nous avons eu le droit à un Patch Day très court chez Microsoft tandis que la glibc s'invite exceptionnellement avec Windows Live Messenger aux côtés de Joomla et nginx. Ceci étant, je vous épargne le Patch day Oracle ainsi que celui de TYPO3.








[![](http://blog.kdecherf.com/wp-content/uploads/2009/12/3S.png)](http://blog.kdecherf.com/wp-content/uploads/2009/12/3S.png)








**Système et applicatif**













**CVE**






**Application**






**Version(s)**






**Détail**







[CVE-2009-4536](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4536), [CVE-2009-4538](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4538)


Linux kernel


<= 2.6.32.3


Détournement de filtre par un paquet surchargé (driver e1000)






[CVE-2009-4537](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4537)


Linux kernel


<= 2.6.32.3


Faille de sécurité permettant un déni de service (driver r8169)






[CVE-2009-4355](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4355)





OpenSSL






<= 0.9.8l,              
<= 1.0.0b4






Fuite mémoire permettant un déni de service







[CVE-2009-4489](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4489)


Cherokee


< 0.99.32


Exécution de code à distance via une requête HTTP mal formée






[CVE-2009-4487](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4487)


nginx


0.7.64


Exécution de code à distance via une requête HTTP mal formée






[CVE-2009-3953](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3953), [CVE-2009-3954](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3954), [CVE-2009-3955](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3955), [CVE-2009-3956](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3956), [CVE-2009-3957](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3957), [CVE-2009-3958](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3958), [CVE-2009-3959](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3959)


Adobe Reader, Acrobar


< 8.2, < 9.3


Exécution de code arbitraire et déni de service






[CVE-2010-0278](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0278)


Windows Live Messenger


14.0.8089.726


Faille de sécurité permettant un déni de service (crash applicatif)






[CVE-2010-0015](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0015)


GNU C Library (glibc, libc6)


2.7


Détournement d'informations des comptes NIS (mots de passe chiffrés)






[CVE-2010-0310](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0310)


Solaris


10


Gain de privilège via _Trusted Extensions_






[CVE-2010-0314](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0314)


Apple Safari




Accès à des données sensibles via la balise <link> dans un contexte d'appel CSS






[CVE-2010-0315](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0315)


Google Chrome




Accès à des données sensibles via la balise <link> dans un contexte d'appel CSS






[CVE-2010-0249](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0249)


Microsoft Internet Explorer


6 - 8


Exécution de code arbitraire, _faille 0-day exploitée courant Janvier_






[CVE-2010-0318](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0318)


FreeBSD


7.1, 7.2 et 8.0


Possibilité de lire ou modifier des fichiers sans autorisation dans un contexte particulier (ZFS)






[CVE-2010-0018](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0018)


Microsoft Windows


2000 SP4, XP SP2-SP3, 2003 SP2, Vista, 2008, 2008 R2 et 7


_Patch Day_ - Exécution de code arbitraire via le moteur de polices de caractères Embedded OpenType (EOT)









**Web**













**CVE**






**Application / Module**






**Version(s)**






**Détail**







[CVE-2009-4598](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4598)


Joomla / JPhoto


1.0


Injection SQL via le paramètre _id_






[CVE-2009-4599](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4599)


Joomla / JS Jobs


1.0.5.6


Injections SQL multiples via les paramètres _md_ et _oi_






[CVE-2009-4604](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4604)


Joomla / Fernando Soares Mamboleto


2.0 RC3


Injection de fichiers PHP via une faille _include_









Voilà pour le 4ème volume du 3S … _Have a nice week_.



