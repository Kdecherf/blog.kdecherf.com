---
date: '2010-01-18 23:59:39'
layout: post
title: 'Sunday Security Summary #4'
categories: [Unclassified]
comments: true
---

Petit point habituel de la semaine passée en matière de sécurité, nous avons eu le droit à un Patch Day très court chez Microsoft tandis que la glibc s'invite exceptionnellement avec Windows Live Messenger aux côtés de Joomla et nginx. Ceci étant, je vous épargne le Patch day Oracle ainsi que celui de TYPO3.

{% img center /images/2009/12/3S.png '3S' '3S' %}

**Système et applicatif**

<table class="post">
 <tr>
  <th>CVE</th>
  <th>Application</th>
  <th>Version(s)</th>
  <th>Détail</th>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4536">CVE-2009-4536</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4538">CVE-2009-4538</a></td>
  <td>Linux kernel</td>
  <td>&lt;= 2.6.32.3</td>
  <td>Détournement de filtre par un paquet surchargé (driver e1000)</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4537">CVE-2009-4537</a></td>
  <td>Linux kernel</td>
  <td>&lt;= 2.6.32.3</td>
  <td>Faille de sécurité permettant un déni de service (driver r8169)</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4355">CVE-2009-4355</a></td>
  <td>OpenSSL</td>
  <td>&lt;= 0.9.81,<br/>&lt;= 1.0.0b4</td>
  <td>Fuite mémoire permettant un déni de service</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4489">CVE-2009-4489</a></td>
  <td>Cherokee</td>
  <td>&lt; 0.99.32</td>
  <td>Exécution de code à distance via une requête HTTP mal formée</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4487">CVE-2009-4487</a></td>
  <td>nginx</td>
  <td>0.7.64</td>
  <td>Exécution de code à distance via une requête HTTP mal formée</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3953">CVE-2009-3953</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3954">CVE-2009-3954</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3955">CVE-2009-3955</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3956">CVE-2009-3956</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3957">CVE-2009-3957</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3958">CVE-2009-3958</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3959">CVE-2009-3959</a></td>
  <td>Adobe Reader, Acrobat</td>
  <td>&lt; 8.2,<br/>&lt; 9.3</td>
  <td>Exécution de code arbitraire et déni de service</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0278">CVE-2010-0278</a></td>
  <td>Windows Live Messenger</td>
  <td>14.0.8089.726</td>
  <td>Faille de sécurité permettant un déni de service (crash applicatif)</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0015">CVE-2010-0015</a></td>
  <td>GNU C Library (glibc, libc6)</td>
  <td>2.7</td>
  <td>Détournement d'informations des comptes NIS (mots de passe chiffrés)</td>
 </tr>
<tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0310">CVE-2010-0310</a></td>
  <td>Solaris</td>
  <td>10</td>
  <td>Gain de privilège via <em>Trusted Extensions</em></td>
 </tr>
<tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0314">CVE-2010-0314</a></td>
  <td>Apple Safari</td>
  <td></td>
  <td>Accès à des données sensibles via la balide &lt;link&gt; dans un contexte d'appel CSS</td>
 </tr>
<tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0315">CVE-2010-0315</a></td>
  <td>Google Chrome</td>
  <td></td>
  <td>Accès à des données sensibles via la balise &lt;link&gt; dans un contexte d'appel CSS</td>
 </tr>
<tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0249">CVE-2010-0249</a></td>
  <td>Microsoft Internet Explorer</td>
  <td>6 - 8</td>
  <td>Exécution de code arbitraire, <em>faille 0-day exploitée courant Janvier</em></td>
 </tr>
<tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0318">CVE-2010-0318</a></td>
  <td>FreeBSD</td>
  <td>7.1, 7.2 et 8.0</td>
  <td>Possibilité de lire ou modifier des fichiers sans autorisation dans un contexte particulier (ZFS)</td>
 </tr>
<tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0018">CVE-2010-0018</a></td>
  <td>Microsoft Windows</td>
  <td>2000 SP4, XP SP2-SP3, 2003 SP2, Vista, 2008, 2008 R2 et 7</td>
  <td>Exécution de code arbitraire via le moteur de polices de caractères Embedded OpenType (EOT)</td>
 </tr>
</table>

**Web**

<table class="post">
 <tr>
  <th>CVE</th>
  <th>Application</th>
  <th>Version(s)</th>
  <th>Détail</th>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4598">CVE-2009-4598</a></td>
  <td>Joomla / JPhoto</td>
  <td>1.0</td>
  <td>Injection SQL via le paramètre <em>id</em></td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4599">CVE-2009-4599</a></td>
  <td>Joomla / JS Jobs</td>
  <td>1.0.5.6</td>
  <td>Injections SQL multiples via les paramètres <em>md</em> et <em>oi</em></td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4604">CVE-2009-4604</a></td>
  <td>Joomla / Fernando Soares Mamboleto</td>
  <td>2.0 RC3</td>
  <td>Injection de fichiers PHP via une faille <em>include</em></td>
 </tr>
</table>

Voilà pour le 4ème volume du 3S … _Have a nice week_.
