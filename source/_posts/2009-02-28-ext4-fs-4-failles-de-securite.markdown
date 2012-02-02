---
date: '2009-02-28 10:25:23'
layout: post
title: 'Ext4 FS : 4 failles de sécurité !'
comments: true
---
Si vous utilisez le format de fichiers **Ext4**, ce billet est pour vous ! Et oui, 4 failles de sécurité sur ce FS.

Les failles listées ci-dessous concernent les noyaux Linux 2.6.27 inférieurs à **2.6.27.19** et 2.6.28 inférieurs à **2.6.28.7**.

* [CVE-2009-0745](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-0745) : Faille de sécurité dans la fonction *ext4_group_add* permettant un déni de service (OOPS) via le montage d’un volume Ext4
* [CVE-2009-0746](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-0746) : Faille de sécurité dans la fonction *make_indexed_dir* permettant un déni de service (OOPS) via le montage d’un volume Ext4
* [CVE-2009-0747](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-0747) : Faille de sécurité dans la fonction *ext4_isize* permettant un déni de service (CPU overload) via le montage d’un volume Ext4
* [CVE-2009-0748](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-0748) : Faille de sécurité dans la fonction *ext4_fill_super* permettant un déni de service (OOPS) via le montage d’un volume Ext4
 
Bonne mise à jour !

_Source : National Vulnerability Database_
