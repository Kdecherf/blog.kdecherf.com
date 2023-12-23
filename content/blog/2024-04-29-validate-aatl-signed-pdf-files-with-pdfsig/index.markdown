---
title: "Validate AATL-signed PDF files with pdfsig"
date: 2024-04-29T18:39:27+02:00
tags:
- "pdf"
---

Some time ago in a previous job I had to check the validity of digital
signatures in PDF files. The "most reliable and easiest" way to do that was to
open the file in _Adobe Acrobat Reader_ and take a look at the signature panel:
it gives details on the signature, its validity and its chain of trust. However
I wanted to find a more "CLI-friendly" way than starting a Windows machine
for this purpose.

Part of poppler utils, _pdfsig_ is a command-line utility that can sign and
verify digital signatures in PDF files. The main limitation here is that
certificates used for these digital signatures are rarely trusted by system
stores: Adobe maintains an internal trust store named AATL (_Adobe Approved
Trust List_) so _pdfsig_ would mostly returns a _"Certificate issuer isn't
trusted"_ error:

```
$ pdfsig signed_file.pdf
Digital Signature Info of: signed_file.pdf
Signature #1:
  - Signer Certificate Common Name: ***
  - Signer full Distinguished Name: ***
  - Signing Time: Feb 02 2023 11:58:26
  - Signing Hash Algorithm: SHA-256
  - Signature Type: adbe.pkcs7.detached
  - Signed Ranges: [0 - 28800], [61570 - 62051]
  - Not total document signed
  - Signature Validation: Signature is Valid.
  - Certificate Validation: Certificate issuer isn't Trusted.
```

However we can tell _pdfsig_ to use a custom NSS database as its trust store.
If we can find a way to retrieve certificates contained in the AATL we should
be able to validate a signed PDF like the Adobe tool would do, mostly.

Unfortunately the only public resource I found about this list is a webpage
listing trusted companies without providing the actual certificates[^1], not at
all helpful for a command-line tool.

While wandering a bit disenchanted on the web I found a project on GitHub that
had an interesting script. This script downloads the certificates related to
the AATL. With these certificates I should be able to build a NSS database.

But before we continue with the database, let's pause for a second and look at
how the script actually retrieves them. In a nutshell they are stored in a PDF
file. So, in order to validate the chain of trust, the client downloads a
specially crafted PDF file from Adobe's servers[^2] and extract an embedded XML
object containing the precious list of certificates.

Excerpt from `extract-adobe-aatl.py`[^3]:
``` python
def main(filename):
    reader = pdfrw.PdfReader(filename)
    verify_signature(reader, filename)

    embedded_files = reader["/Root"]["/Names"]["/EmbeddedFiles"]
    if embedded_files["/Names"][0] != ATTACHMENT_NAME:
        raise Exception("Unexpected attachment name %s" %
                        embedded_files["/Names"][0])

    file_spec = embedded_files["/Names"][1]
    embedded_file = file_spec["/EF"][pdfrw.PdfName("F")]
    if embedded_file["/Filter"] != "/FlateDecode":
        raise NotImplementedError("Unsupported compression algorithm %s" %
                                  embedded_file["/Filter"])

    xml = zlib.decompress(embedded_file.stream)
    doc = lxml.etree.fromstring(xml)
    trusted_identities = doc[0]
    for identity in trusted_identities:
# [snipped]
```

I needed to adjust a few things to make it work, which gives the following script:

{{< collapse summary="Click to expand" >}}

``` python
#!/bin/python2

import binascii
import lxml.etree
import os
import subprocess
import sys
import zlib
import fitz

ATTACHMENT_NAME = ("(\xfe\xff\0S\0e\0c\0u\0r\0i\0t\0y\0S\0e\0t\0t\0i\0n\0g\0s"
                   "\0.\0x\0m\0l)")
HEADER = "-----BEGIN CERTIFICATE-----"
FOOTER = "-----END CERTIFICATE-----"

SIGNATURE_FILE_NAME = "signature.der"
MESSAGE_FILE_NAME = "message.bin"


def base64_to_pem(value):
    chunks = [value[i:i + 64] for i in range(0, len(value), 64)]
    lines = [HEADER] + chunks + [FOOTER]
    return "\n".join(lines)


def main(filename):
    file = fitz.open(filename)

    content = file.embfile_get('SecuritySettings.xml')
    doc = lxml.etree.fromstring(content.decode('utf-8'))
    trusted_identities = doc[0]
    for identity in trusted_identities:
        import_action = identity.xpath("ImportAction/text()")[0]
        source = identity.xpath("Identification/Source/text()")[0]
        if import_action not in ("1", "2", "3"):  # what is the difference?
            raise Exception("Unrecognized ImportAction %s" % import_action)
        if source != "AATL":
            raise Exception("Unrecognized source %s" % import_action)

        cert_pem = base64_to_pem(identity.xpath("Certificate/text()")[0])
        process = subprocess.Popen(["openssl",
                                    "x509",
                                    "-noout",
                                    "-fingerprint"],
                                   stdin=subprocess.PIPE,
                                   stdout=subprocess.PIPE)
        fingerprint = process.communicate(input=cert_pem.encode('utf-8'))[0]
        if process.returncode != 0:
            raise subprocess.CalledProcessError()

        fingerprint = fingerprint.decode('utf-8').replace("SHA1 Fingerprint=", "")
        fingerprint = fingerprint.replace(":", "")
        fingerprint = fingerprint.strip()

        f = open(fingerprint + ".pem", "w")
        f.write(cert_pem)
        f.close()


if __name__ == "__main__":
    if len(sys.argv) == 2:
        main(sys.argv[1])
    else:
        print >> sys.stderr, ("Usage: python2 extract-adobe-aatl.py "
                              "<filename.acrobatsecuritysettings>")
```

{{</ collapse >}}

Install the following dependencies if you want to play with it:

``` bash
pip install lxml pdfrw frontend tools PyMuPDF
```

Once we have all the certificates in PEM format we can use the `certutil` tool
from NSS to build a database in a folder named `pki`:

``` bash
mkdir pki
find -type f -name "*.pem" | while read f
do certutil -A -d pki -i $f -n $f -t TCu,Cu,Tu
done
```

Then with this custom database `pdfsig` should now trust the certificate
issuer:

```
$ pdfsig -nssdir pki signed_file.pdf
Digital Signature Info of: signed_file.pdf
Signature #1:
[clipped]
- Signature Validation: Signature is Valid.
- Certificate Validation: Certificate is Trusted.
```

#### Further reading

I'm anything but an expert in this field, that's why I didn't really talked
about what is a digital signature. But I can summarize a few things and give
you some links if you want to dig more.

Digital signatures in PDF files is far from being a recent topic. While early
stages were quite proprietary and specific to Adobe, things evolved
significantly these past 15 years. Two important events happened:

- The release of the _ISO 32000-1_[^4] around 2009 which marked the standardization of
  the PDF format and introduced several features for digital signatures,
  including _PAdES_[^5]

- The introduction of the _Regulation (EU) No 910/2014_, also known as _eIDAS
  Regulation_[^6], between 2014 and 2016, bringing a framework for electronic
  identification and trust services, mainly for the EU market

Here are a few more links:

- {{< wayback "http://www.etsi.org/WebSite/NewsandEvents/200909_ElectronicSignature.aspx" "20120414190513" >}}New ETSI standard for EU-compliant electronic signature press release{{</ wayback >}}
- {{< wayback "https://blogs.adobe.com/security/2009/09/eliminating_the_penone_step_at.html" "20100710170245" >}}Adobe blog post on PAdES introduction{{</ wayback >}}
- [eSignature Validator tool on _eIDAS Dashboard_](https://eidas.ec.europa.eu/efda/validation-tool)
- [Validating digital signature page on _Adobe Support_](https://helpx.adobe.com/acrobat/using/validating-digital-signatures.html)
- [Adobe Approved Trust List page on _Adobe Support_](https://helpx.adobe.com/acrobat/kb/approved-trust-list2.html)
- [European Union Trusted List page on _Adobe Support_](https://helpx.adobe.com/document-cloud/kb/european-union-trust-lists.html)

_Enjoy_

[^1]: _Adobe Approved Trust List Members_ https://helpx.adobe.com/acrobat/kb/approved-trust-list1.html
[^2]: http://trustlist.adobe.com/tl10.acrobatsecuritysettings
[^3]: https://github.com/kirei/catt/blob/master/scripts/extract-adobe-aatl.py
[^4]: Adobe version of the ISO 32000-1 standard https://opensource.adobe.com/dc-acrobat-sdk-docs/pdfstandards/PDF32000_2008.pdf
[^5]: _PAdES on Wikipedia_ https://en.wikipedia.org/wiki/PAdES
[^6]: _eIDAS on Wikipedia_ https://en.wikipedia.org/wiki/EIDAS
