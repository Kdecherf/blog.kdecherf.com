Date: 2011-06-19 19:35:11
Title: Java/Jersey: A CORS-Compliant REST API (die JSONP die)
Category: Blog
Tags: java
Slug: java-jersey-a-cors-compliant-rest-api

Une traduction française est disponible [ici](/blog/2011/06/02/java-jersey-une-api-rest-cross-domain-sans-jsonp/).

<div class="alert-info">
  <strong>UPDATE 2012/12/23:</strong> fixing typo on line 4, <code>ResponseBuilder</code> has no <code>ok()</code> method (<em>Thanks <a href="#comment-658615663">Frankie Frank</a></em>).
</div>

Cross-Domain AJAX request is the developer's nightmare with the awful JSONP workaround. But we can use a simple standard to kick off this bad practice.

### Reminder

When a developer needs to make cross-domain requests (_AJAX requests on another (sub-)domain or non-standard port, limited by browsers_), he often uses the JSONP workaround : we add a Javascript callback in the API response and we 'eval' it.

For a recent project I refused to use JSONP to make my REST API cross-domain compatible, so I looked for an alternative solution. This solution is Cross-Origin Resource Sharing (CORS), a W3C standard.

### Synopsis

In the last revision of the document, new headers are added to the HTTP protocol (_Not used by RFC 2616_) and a special request (_preflight request_) was created for cross-domain rights access control during an AJAX request.

**Browser side**  

  * **Origin**: shows the request domain
  * **Access-Control-Request-Method**: shows the request HTTP verb
  * **Access-Control-Request-Headers**: shows additional headers used by browser and must be authorised by server to continue AJAX requests

**Server side**  

  * **Access-Control-Allow-Origin**: indicates authorised domains to make cross-domain requests (_should contain at least value of 'Origin' header or '*'_)
  * **Access-Control-Allow-Credentials**: indicates if server allow credentials during CORS requests
  * **Access-Control-Expose-Headers**: indicates allowed headers to be sent to the browser
  * **Access-Control-Max-Age**: indicates how long a response to a preflight request can be cached
  * **Access-Control-Allow-Methods**: indicates all allowed HTTP verbs for cross-domain requests (should contain at least the 'Access-Control-Request-Method' header value)
  * **Access-Control-Allow-Headers**: indicates allowed custom headers to be used by browser during cross-domain requests (should contain at least the 'Access-Control-Request-Headers' header value)

In this post, I don't use _Access-Control-Allow-Credentials_, _Access-Control-Expose-Headers_ and _Access-Control-Max-Age_ headers.

### How does it work ?

For standard requests, the browser will add _Origin_ and _Access-Control-Request-Method_ headers. A preflight request will be executed before the actual request if it contains custom headers, if it uses another HTTP verb than GET or POST or also if the body isn't in text/plain format (ie. application/json).

There is a preflight request made by Firefox :

``` http
OPTIONS /url HTTP/1.1
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

We can see _Origin_, _Access-Control-Request-Method_ and _Access-Control-Request-Headers_ headers. After this request, Firefox waits a similar response:

```
X-Powered-By: Servlet/3.0
Server: GlassFish Server Open Source Edition 3.0.1
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: x-requested-with
```

After this, Firefox can continue with its requests and adds a custom header:

```
X-Requested-With: XMLHttpRequest
```

### And our API ?

Well, now we modify our API to be CORS-compliant using Java and Jersey. You can add a simple method like this:

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

Because of I didn't find the catch-all @Path, we need to add methods as many as paths the API manage:

``` java
   // This OPTIONS request/response is necessary
   // if you consumes other format than text/plain or
   // if you use other HTTP verbs than GET and POST
   @OPTIONS
   @Path("/myresource")
   public Response corsMyResource(@HeaderParam("Access-Control-Request-Headers") String requestH) {
      _corsHeaders = requestH;
      return makeCORS(Response.ok(), requestH);
   }

   @GET
   @Path("/myresource")
   public Response myResource() {
      // myResponse is a ResponseBuilder object
      return makeCORS(myResponse);
   }
```

These code snippets are given only as an example, you can change it to build _Access-Control-Allow-Methods_ according to the API's WADL scheme or add a restrictive _Access-Control-Allow-Origin_ rule.

### What about browser compatibility ?

With this standard you can miss Internet Explorer 6 and 7. Internet Explorer 8 is saved by a new _XDomainRequest_ object replacing _XMLHttpRequest_ but seems to be not compatible with preflight requests. Other browsers are globally compatible with their last versions.


**More information:**

  * [W3C Worksheet about CORS](http://www.w3.org/TR/cors/)
  * [Using CORS with Firefox 3.5](https://developer.mozilla.org/En/HTTP_Access_Control)
  * [XDomainRequest object on MSDN](http://msdn.microsoft.com/en-us/library/cc288060\(v=vs.85\).aspx)
  * [RFC 2616: HTTP Protocol](http://tools.ietf.org/html/rfc2616)


_Enjoy it!_
