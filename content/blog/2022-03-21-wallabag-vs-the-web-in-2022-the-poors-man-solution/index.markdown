---
title: "wallabag vs the web in 2022: the poor's man solution"
date: 2022-03-21T13:16:59+01:00
tags:
- wallabag
---

{{< alertbox "info" "Disclaimer" >}}
  I made this dirty implementation several months ago; while this blog post was
  still a draft, someone implemented the missing feature in wallabagger and it
  was shipped in
  <a href="https://github.com/wallabag/wallabagger/releases/tag/v1.14.0">v1.14.0</a>.
  However I've decided to publish this post anyway, for the record.
{{< /alertbox >}}

This post is the first of a series about wallabag and the dirty things I do
with it.

It has been mostly 6 years since I started to use wallabag as my main tool to
read content on the web; and I quickly started contributing to it on my sparse
time. wallabag does not only save pages I want to read, it also saves me time
by avoiding all these pesky pop-ups, ads and other cookiewalls.

In order to do that, wallabag retrieves the content of an article by making a
basic HTTP call and parsing the HTML file it receives in response. This works
in most cases but it can be defeated by bot protection or if the page loads its
content using javascript, e.g. on Bloomberg or websites behind Cloudflare.

For a while I accepted this fate but lately I decided to find a workaround in
order to continue reading 'cleaned' articles.

The easiest way to achieve that is to save the content directly from the browser
as you surf through it. Okay, we know the destination but how do we go there?

[Wallabagger][:wallabagger] is a browser extension that lets you save pages to
your wallabag's account. ~~As of now it only takes the url of the active page and
sends it to wallabag, letting the server fetching the content.~~

The logical path would be to update the extension to add the ability to capture
and send the actual content in addition to the url.

Spoiler alert: I decided to go over another way; my willingness to do
JavaScript was pretty low 🙃. While searching for browser extensions capable of
saving pages, I came accross several interesting ones:

* [WebScrapBook][:webscrapbook]
* [SingleFile][:singlefile]

They both save the content of the page locally and do it well; but WebScrapBook
has a feature that attracted my attention: the support of a backend to store
the saved content remotely. I found a [working backend implementation in
Python][:pywebscrapbook].

A few hours later I had a very limited but working WebScrapBook backend API
support in wallabag. It basically relies on the import mechanism and
on [a recent change][:graby] that landed in Graby.

Here is the raw patch:

{{< collapse summary="Click to expand" >}}

``` diff
diff --git a/src/Wallabag/CoreBundle/Helper/ContentProxy.php b/src/Wallabag/CoreBundle/Helper/ContentProxy.php
index ed706680b..1c990c47c 100644
--- a/src/Wallabag/CoreBundle/Helper/ContentProxy.php
+++ b/src/Wallabag/CoreBundle/Helper/ContentProxy.php
@@ -26,6 +26,7 @@ class ContentProxy
     protected $fetchingErrorMessage;
     protected $eventDispatcher;
     protected $storeArticleHeaders;
+    protected $offlineMode = false;
 
     public function __construct(Graby $graby, RuleBasedTagger $tagger, RuleBasedIgnoreOriginProcessor $ignoreOriginProcessor, ValidatorInterface $validator, LoggerInterface $logger, $fetchingErrorMessage, $storeArticleHeaders = false)
     {
@@ -50,11 +51,14 @@ class ContentProxy
     public function updateEntry(Entry $entry, $url, array $content = [], $disableContentUpdate = false)
     {
         $this->graby->toggleImgNoReferrer(true);
-        if (!empty($content['html'])) {
+        if (!empty($content['html']) && !$this->offlineMode) {
             $content['html'] = $this->graby->cleanupHtml($content['html'], $url);
         }
 
         if ((empty($content) || false === $this->validateContent($content)) && false === $disableContentUpdate) {
+            if ($this->offlineMode) {
+                $this->graby->setContentAsPrefetched($content['html']);
+            }
             $fetchedContent = $this->graby->fetchContent($url);
 
             $fetchedContent['title'] = $this->sanitizeContentTitle(
@@ -158,6 +162,10 @@ class ContentProxy
         }
     }
 
+    public function setOfflineMode(bool $offlineMode) {
+        $this->offlineMode = $offlineMode;
+    }
+
     /**
      * Helper to extract and save host from entry url.
      */
diff --git a/src/Wallabag/ImportBundle/Controller/WebScrapBookController.php b/src/Wallabag/ImportBundle/Controller/WebScrapBookController.php
new file mode 100644
index 000000000..4ab2ba6f2
--- /dev/null
+++ b/src/Wallabag/ImportBundle/Controller/WebScrapBookController.php
@@ -0,0 +1,118 @@
+<?php
+
+namespace Wallabag\ImportBundle\Controller;
+
+use Symfony\Bundle\FrameworkBundle\Controller\Controller;
+use Symfony\Component\HttpFoundation\Request;
+use Symfony\Component\Routing\Annotation\Route;
+use Symfony\Component\HttpFoundation\JsonResponse;
+use JMS\Serializer\SerializationContext;
+use Symfony\Component\HttpFoundation\File\UploadedFile;
+use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
+
+class WebScrapBookController extends Controller
+{
+    private $token = "v3ry53cur3w0w";
+
+    /**
+    * @Route("/wsb/")
+    */
+    public function indexAction(Request $request) {
+        switch ($request->query->get('a')) {
+        case 'config':
+            $config = [
+                "app" => [
+                    "name" => "WebScrapBook (Wallabag)",
+                    "theme" => "default",
+                    "locale" => "",
+                    "base" => "/import/wsb",
+                    "is_local" => true,
+                ],
+                "book" => [
+                    "" => [
+                        "name" => "scrapbook",
+                        "top_dir" => "",
+                        "data_dir" => "",
+                        "tree_dir" => ".wsb/tree",
+                        "index" => ".wsb/tree/map.html",
+                        "no_tree" => true,
+                    ],
+                ],
+                "VERSION" => "0.44.1",
+                "WSB_DIR" => ".wsb",
+                "WSB_CONFIG" => "config.ini",
+                "WSB_EXTENSION_MIN_VERSION" => "0.79.0",
+            ];
+            return $this->sendResponse($config);
+            break;
+        case 'token':
+            return $this->sendResponse(password_hash($this->token, \PASSWORD_BCRYPT));
+            break;
+        default:
+            return $this->sendResponse(new \StdClass(), false);
+        }
+    }
+
+    /**
+     * @Route("/wsb/{page}.html", name="wsb_get_page", requirements={"page"="\S+"}, methods={"GET"})
+     */
+    public function getPageAction(Request $request) {
+        $obj = [
+            "name" => $request->query->get('page') . ".html",
+            "type" => null,
+            "size" => null,
+            "last_modified" => null,
+            "mime" => "text/html",
+        ];
+        return $this->sendResponse($obj);
+    }
+
+    /**
+     * @Route("/wsb/{page}.html", name="wsb_save_page", requirements={"page"="\S+"}, methods={"POST"})
+     */
+    public function postPageAction(Request $request) {
+        $uploadedFile = $request->files->get('upload');
+        if (!($uploadedFile instanceof UploadedFile)) {
+            throw new BadRequestHttpException();
+        }
+
+        $wsb = $this->get('wallabag_import.wsb.import');
+        $wsb->setUser($this->getUser());
+        $i = $wsb->setFilepath($uploadedFile->getPathname())->import();
+
+        if (false === $i) {
+            throw new BadRequestHttpException();
+        }
+        return $this->sendResponse("Command run successfully.");
+    }
+
+    /**
+     * @Route("/wsb/{path}")
+     */
+    public function catchAllAction() {
+        return $this->sendResponse(new \StdClass());
+    }
+
+    /**
+     * Shortcut to send data serialized in json.
+     *
+     * @param mixed $data
+     *
+     * @return JsonResponse
+     */
+    protected function sendResponse($data, $success = true)
+    {
+        // https://github.com/schmittjoh/JMSSerializerBundle/issues/293
+        $context = new SerializationContext();
+        $context->setSerializeNull(true);
+
+        $obj = [
+            "success" => $success,
+            "data" => $data,
+        ];
+
+        $json = $this->get('jms_serializer')->serialize($obj, 'json', $context);
+
+        return (new JsonResponse())->setJson($json);
+    }
+}
diff --git a/src/Wallabag/ImportBundle/Import/WebScrapBookImport.php b/src/Wallabag/ImportBundle/Import/WebScrapBookImport.php
new file mode 100644
index 000000000..0c7cd5496
--- /dev/null
+++ b/src/Wallabag/ImportBundle/Import/WebScrapBookImport.php
@@ -0,0 +1,162 @@
+<?php
+
+namespace Wallabag\ImportBundle\Import;
+
+use Wallabag\CoreBundle\Entity\Entry;
+use Wallabag\CoreBundle\Event\EntrySavedEvent;
+
+class WebScrapBookImport extends AbstractImport
+{
+    protected $filepath;
+
+    /**
+     * {@inheritdoc}
+     */
+    public function getName()
+    {
+        return 'WebScrapBook';
+    }
+
+    /**
+     * {@inheritdoc}
+     */
+    public function getUrl()
+    {
+        return 'import_wsb';
+    }
+
+    /**
+     * {@inheritdoc}
+     */
+    public function getDescription()
+    {
+        return 'import.wsb.description';
+    }
+
+    /**
+     * {@inheritdoc}
+     */
+    public function validateEntry(array $importedEntry)
+    {
+        if (empty($importedEntry['uri'])) {
+            return false;
+        }
+
+        return true;
+    }
+
+    /**
+     * {@inheritdoc}
+     */
+    protected function prepareEntry(array $entry = [])
+    {
+        $data = [
+            'title' => false,
+            'html' => $entry['html'],
+            'url' => $entry['url'],
+            'is_archived' => false,
+            'is_starred' => false,
+            'tags' => '',
+        ];
+
+        if (\array_key_exists('tags', $entry) && '' !== $entry['tags']) {
+            $data['tags'] = $entry['tags'];
+        }
+
+        return $data;
+    }
+
+    /**
+     * {@inheritdoc}
+     */
+    public function import()
+    {
+        if (!file_exists($this->filepath) || !is_readable($this->filepath)) {
+            $this->logger->error('WebScrapBookImport: unable to read file', ['filepath' => $this->filepath]);
+
+            return false;
+        }
+
+        $data = file_get_contents($this->filepath);
+
+        if (empty($data)) {
+            $this->logger->error('WebScrapBookImport: empty content');
+
+            return false;
+        }
+
+        if (!($source = $this->getScrapSource($data))) {
+            $this->logger->error('WebScrapBookImport: scrap source not found');
+
+            return false;
+        }
+
+        $entry = $this->parseEntry([
+            "url" => $source,
+            "html" => $data,
+        ]);
+
+        return null !== $entry;
+    }
+
+    private function getScrapSource($data) {
+        if (!preg_match('/data-scrapbook-source="([^\"]+)"/i', $data, $scrap)) {
+            return false;
+        }
+        return array_key_exists(1, $scrap) ? $scrap[1] : false;
+    }
+
+    /**
+     * {@inheritdoc}
+     */
+    public function parseEntry(array $importedEntry)
+    {
+        /* $existingEntry = $this->em
+            ->getRepository('WallabagCoreBundle:Entry')
+            ->findByUrlAndUserId($importedEntry['url'], $this->user->getId());
+
+        if (false !== $existingEntry) {
+            ++$this->skippedEntries;
+
+            return;
+        } */
+
+        $data = $this->prepareEntry($importedEntry);
+
+        $entry = new Entry($this->user);
+        $entry->setUrl($data['url']);
+        $entry->setTitle($data['title']);
+
+        // update entry with content (in case fetching failed, the given entry will be return)
+        $this->contentProxy->setOfflineMode(true);
+        $this->fetchContent($entry, $data['url'], $data);
+
+        $this->em->persist($entry);
+        $this->em->flush();
+        $this->eventDispatcher->dispatch(EntrySavedEvent::NAME, new EntrySavedEvent($entry));
+
+        return $entry;
+    }
+
+    /**
+     * {@inheritdoc}
+     */
+    protected function setEntryAsRead(array $importedEntry)
+    {
+        $importedEntry['is_archived'] = 1;
+
+        return $importedEntry;
+    }
+
+    /**
+     * Set file path to the json file.
+     *
+     * @param string $filepath
+     */
+    public function setFilepath($filepath)
+    {
+        $this->filepath = $filepath;
+
+        return $this;
+    }
+}
diff --git a/src/Wallabag/ImportBundle/Resources/config/services.yml b/src/Wallabag/ImportBundle/Resources/config/services.yml
index d824da4ab..5a7895e07 100644
--- a/src/Wallabag/ImportBundle/Resources/config/services.yml
+++ b/src/Wallabag/ImportBundle/Resources/config/services.yml
@@ -119,6 +119,18 @@ services:
         tags:
             -  { name: wallabag_import.import, alias: chrome }
 
+    wallabag_import.wsb.import:
+        class: Wallabag\ImportBundle\Import\WebScrapBookImport
+        arguments:
+            - "@doctrine.orm.entity_manager"
+            - "@wallabag_core.content_proxy"
+            - "@wallabag_core.tags_assigner"
+            - "@event_dispatcher"
+        calls:
+            - [ setLogger, [ "@logger" ]]
+        tags:
+            -  { name: wallabag_import.import, alias: wsb }
+
     wallabag_import.command.import:
         class: Wallabag\ImportBundle\Command\ImportCommand
         tags: ['console.command']
```
{{< /collapse >}}

As you can see, there is a hardcoded token which acts as a password for
WebScrapBook. It also means that this only works for single-user instances.

Now that wallabag can act as a WebScrapBook remote backend, we configure the
browser extension accordingly:

![screenshot](screenshot.png)

The address is your wallabag's address with `/import/wsb/` appended. Use your
account's email address as the user and the token you set earlier as the
password. You can also change some settings if you want to handle images, fonts
and other things in a specific way.

Now, when you hit _"Capture tabs"_, WebScrapBook grabs the loaded content and
saves it to wallabag.

This solution is not bulletproof however; up until now I encountered two
drawbacks:

1. Some websites alter the page content using JavaScript after initial loading,
   baring the browser extension from grabbing the page fully. "Capture tabs
   (source)" can fix this but not always
2. Objects like iframes and SVG are still missing in the saved entry (_and it
   really annoys me_)

Anyway, here we are, with a dirty but working solution to capture pages that
can't be normally saved by wallabag.

I guess you're telling yourself that adding the missing feature to wallabagger
would probably be more relevant. I will be honest: I won't take time to do it.
~~But if you want to contribute, feel free to open a PR on its repository.~~  
_Edit: an equivalent feature has been released in last wallabagger version._

~~Regarding the WebScrapBook backend support in wallabag, I'm considering it for
inclusion in upstream. Feel free to give your feedback on GitHub, Twitter or
Reddit about it.~~  
_Edit: now that wallabagger is able to do the same thing, I don't think it's
relevant to push this implementation upstream._

Last but not least, I would be pleased to hear you if you have ideas or already
worked on a generic way to capture embedded contents like SVGs (_e.g. charts on
medias like The Guardian_) in a way that would fit wallabag.

_Enjoy!_

[:wallabagger]: https://github.com/wallabag/wallabagger
[:webscrapbook]: https://github.com/danny0838/webscrapbook
[:singlefile]: https://github.com/gildas-lormeau/SingleFile
[:pywebscrapbook]: https://github.com/danny0838/PyWebScrapBook
[:graby]: https://github.com/j0k3r/graby/pull/274
