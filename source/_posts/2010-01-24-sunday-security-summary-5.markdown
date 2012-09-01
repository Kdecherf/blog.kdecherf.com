---
date: '2010-01-24 17:30:25'
layout: post
title: 'Sunday Security Summary #5'
comments: true
---

Cette semaine s'est placée sous le signe d'une faille de sécurité très critiquée sur Internet Explorer ce qui a valu à Microsoft de sortir un patch plus tôt que prévu. Flash, BIND, Linux et PHPMyAdmin l'accompagnent.

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
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0007">CVE-2010-0007</a></td>
  <td>Linux kernel</td>
  <td>&lt; 2.6.33-rc4</td>
  <td>Détournement de privilèges permettant la libre modification des règles de filtrage d'<em>ebtables</em></td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4141">CVE-2009-4141</a></td>
  <td>Linux kernel</td>
  <td>&lt; 2.6.33-rc4-git1</td>
  <td>Gain de privilège</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0244">CVE-2010-0244</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0245">CVE-2010-0245</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0246">CVE-2010-0246</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0247">CVE-2010-0247</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0248">CVE-2010-0248</a></td>
  <td>Internet Explorer</td>
  <td>5.01 SP4, 6, 6 SP1, 7, 8</td>
  <td>Exécution de code arbitraire et corruption de mémoire</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0027">CVE-2010-0027</a></td>
  <td>Internet Explorer</td>
  <td>7, 8</td>
  <td>Exécution de programme local via l'outil de validation des URLs</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0097">CVE-2010-0097</a></td>
  <td>ISC BIND</td>
  <td>9.0.x à 9.3.x, &lt; 9.4.3-P5, &lt; 9.5.2-P2, &lt; 9.6.1-P3, 9.7.0b</td>
  <td>Injection de données (<em>AD flag</em>) sur des réponses valides</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0290">CVE-2010-0290</a></td>
  <td>ISC BIND</td>
  <td>9.0.x à 9.3.x, &lt; 9.4.3-P5, &lt; 9.5.2-P2, &lt; 9.6.1-P3, 9.7.0b</td>
  <td><em>DNS cache poisoning</em></td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0382">CVE-2010-0382</a></td>
  <td>ISC BIND</td>
  <td>9.0.x à 9.3.x, &lt; 9.4.3-P5, &lt; 9.5.2-P2, &lt; 9.6.1-P3, 9.7.0b</td>
  <td>Faille de sécurité générée par la correction de CVE-2009-4022, impact inconnu</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0379">CVE-2010-0379</a></td>
  <td>Flash Player</td>
  <td>6</td>
  <td>Exécution de code arbitraire <br /><em>Note : ActiveX distribué avec Windows XP SP2 et SP3</em></td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0378">CVE-2010-0378</a></td>
  <td>Flash Player</td>
  <td>6.0.79</td>
  <td>Exécution de code arbitraire <br /><em>Note : ActiveX distribué avec Windows XP SP2 et SP3</em></td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0037">CVE-2010-0037</a></td>
  <td>Apple Mac OS X</td>
  <td>10.5.8, 10.6.2</td>
  <td>Exécution de code arbitraire ou déni de service via l'application Image RAW</td>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2010-0036">CVE-2010-0036</a></td>
  <td>Apple Mac OS X</td>
  <td>10.5.8, 10.6.2</td>
  <td>Exécution de code arbitraire ou déni de service via l'application CoreAudio</td>
 </tr>
</table>

**Applications web**

<table class="post">
 <tr>
  <th>CVE</th>
  <th>Application</th>
  <th>Version(s)</th>
  <th>Détail</th>
 </tr>
 <tr>
  <td><a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-4605">CVE-2009-4605</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2008-7252">CVE-2008-7252</a>, <a href="http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2008-7251">CVE-2010-7251</a></td>
  <td>phpMyAdmin</td>
  <td>2.11.x &lt; 2.11.10</td>
  <td>Attaque CSRF et failles de sécurité à impact inconnu</td>
 </tr>
</table>
