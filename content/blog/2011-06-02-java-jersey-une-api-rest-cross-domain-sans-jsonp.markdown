Date: 2011-06-02 17:35:07
Title: Java/Jersey : une API REST Cross-Domain sans JSONP
Category: Blog
Tags: java
Slug: java-jersey-une-api-rest-cross-domain-sans-jsonp

An english version of this post is available [here](/blog/2011/06/19/java-jersey-a-cors-compliant-rest-api/).

<div class="alert-info">
  <strong>UPDATE 2012/12/23:</strong> Correction d'une erreur d'étourderie sur le premier bloc ligne 4, l'objet <code>ResponseBuilder</code> n'a pas de méthode <code>ok()</code>.
</div>

Ah les joies d'AJAX et du Cross-Domain ... Ou plutôt le cauchemar des développeurs. Aujourd'hui, je vais vous présenter un concept pour rendre rapidement et simplement une API REST Java/Jersey compatible avec la norme W3C CORS pour faire du Cross-Domain sans utiliser JSONP.

### Contexte

La plupart du temps, quand un développeur doit faire des requêtes Cross-Domain, il n'a pas d'autres choix que d'utiliser du JSONP : un callback est injecté dans une réponse en JSON puis le résultat est directement exécuté en Javascript. Cette méthode est lourde et relativement sale (_et sur le coup j'avoue ne pas être assez sale pour l'utiliser_).

Dans le cadre d'une mission où nous devions réaliser une API REST, j'ai décidé de trouver une autre solution que de faire du JSONP. La réponse se trouve dans la dernière révision de la norme Cross-Origin Resource Sharing (CORS) du W3C.

### Principe

Cette dernière révision nous présente l'ajout d'en-têtes spéciaux (_qui ne font pas partie de la RFC 2616_) et de la _preflight request_ exécutée par le navigateur avant d'envoyer sa requête AJAX pour vérifier les permissions d'accès.

**Côté navigateur**  

  * **Origin**: indique le domaine de la requête
  * **Access-Control-Request-Method**: indique la méthode utilisée dans la requête
  * **Access-Control-Request-Headers**: indique l'en-tête qui sera utilisé par le navigateur et devra être autorisé par le serveur pour terminer la requête (utilisé lors d'une requête _preflight_)

**Côté serveur**  

  * **Access-Control-Allow-Origin**: indique le(s) domaine(s) autorisé(s) à faire des requêtes Cross-Domain (doit contenir au minimum le résultat de _Origin_ ou \*)
  * **Access-Control-Allow-Credentials**: indique si l'utilisation de credentials est autorisée lors d'une requête Cross-Domain (Cookie, HTTP Authentication, ...)
  * **Access-Control-Expose-Headers**: indique les en-têtes pouvant être exposés sans risque à un navigateur
  * **Access-Control-Max-Age**: indique le temps dont une réponse à une _preflight request_ peut être mise en cache par le navigateur
  * **Access-Control-Allow-Methods**: indique la liste des verbes HTTP pouvant être utilisés pour une requête Cross-Domain (doit contenir au minimum le résultat de _Access-Control-Request-Method_)
  * **Access-Control-Allow-Headers**: indique la liste des en-têtes personnalisés autorisés pour une requête Cross-Domain (doit contenir au minimum le résultat de _Access-Control-Request-Headers_)

Dans ce billet, je mets de côté _Access-Control-Allow-Credentials_, _Access-Control-Expose-Headers_ et _Access-Control-Max-Age_.

### Dans les faits

En condition normale, le navigateur va ajouter les en-têtes _Origin_ et _Access-Control-Request-Method_ lors de la requête. Une requête préliminaire sera faite (_preflight request_) si des en-têtes personnalisés sont présents, si la requête utilise une méthode autre que _GET_ et _POST_ ou encore que le client envoie des données qui ne sont pas au format text/plain (du JSON par exemple).

Voici un exemple de _preflight request_ envoyée par Firefox :
``` http
OPTIONS /monurl HTTP/1.1
Host: 127.0.0.1:5555
User-Agent: Mozilla/5.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-us,en;q=0.5
Accept-Encoding: gzip,deflate
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
Keep-Alive: 115
Connection: keep-alive
Origin: http://127.0.0.1
Access-Control-Request-Method: POST
Access-Control-Request-Headers: x-requested-with
```

On remarque bien les en-têtes _Origin_, _Access-Control-Request-Method_ et _Access-Control-Request-Headers_. Maintenant, Firefox s'attend à recevoir une réponse de ce style de la part du serveur (exemple) :
```
X-Powered-By: Servlet/3.0
Server: GlassFish Server Open Source Edition 3.0.1
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: x-requested-with
```

A ce niveau, Firefox sait qu'il peut faire des requêtes AJAX vers ce serveur, il continue donc avec ses requêtes normales en ajoutant son en-tête personnalisé :
```
X-Requested-With: XMLHttpRequest
```

### Et notre API ?

J'y viens, côté code maintenant nous considérons avoir une API REST déjà faite (en utilisant Jersey). Il suffit d'ajouter une fonction similaire à celle-là :
``` java
private String _corsHeaders;

private Response makeCORS(ResponseBuilder req, String returnMethod) {
   ResponseBuilder rb = req.header("Access-Control-Allow-Origin", "*")
      .header("Access-Control-Allow-Methods", "GET, POST, OPTIONS");

   if (!"".equals(returnMethod)) {
      rb.header("Access-Control-Allow-Headers", returnMethod);
   }

   return rb.build();
}

private Response makeCORS(ResponseBuilder req) {
   return makeCORS(req, _corsHeaders);
}
```

Puis d'ajouter autant de fonctions comme celle-ci que de @Path à gérer (_je n'ai pas réussi à trouver le @Path "catch-all"_) :
``` java
   // La méthode OPTIONS doit être gérée si vous faites des requêtes
   // avec autre chose que du GET, POST ou que le client transmet
   // des données dans un format différent de text/plain
   @OPTIONS
   @Path("/maressource")
   public Response corsMaRessource(@HeaderParam("Access-Control-Request-Headers") String requestH) {
      _corsHeaders = requestH;
      return makeCORS(Response.ok(), requestH);
   }

   @GET
   @Path("/maressource")
   public Response maRessource() {
      // Traitement de la requête, ResponseBuilder maReponse
      return makeCORS(maReponse);
   }
```

Bien entendu, ceci n'est donné qu'à titre d'exemple et libre à vous d'adapter. Entre autre renseigner dynamiquement _Access-Control-Allow-Methods_ en fonction de l'API et de son WADL ou encore restreindre _Access-Control-Allow-Origin_.

### Et la compatibilité dans tout ça ?

Point de vue compatibilité avec cette petite norme laissez tomber Internet Explorer 6 et 7, quant à Internet Explorer 8 on est sauvé par l'ajout d'un objet spécial `XDomainRequest` remplaçant `XMLHttpRequest`. A noter cependant que l'objet `XDomainRequest` ne semble pas être compatible avec les _preflight requests_. Pour les autres navigateurs ça tourne globalement partout avec les dernières versions.

**Plus d'informations :**

  * [Document de travail du W3C pour la norme CORS](http://www.w3.org/TR/cors/)
  * [Présentation détaillée de l'utilisation de CORS avec Firefox 3.5](https://developer.mozilla.org/En/HTTP_Access_Control)
  * [Présentation de l'objet XDomainRequest sur MSDN](http://msdn.microsoft.com/en-us/library/cc288060\(v=vs.85\).aspx)
  * [RFC 2616 : Protocole HTTP](http://tools.ietf.org/html/rfc2616)


_Enjoy it!_
