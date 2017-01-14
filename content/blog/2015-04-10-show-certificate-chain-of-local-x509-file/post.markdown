Date: 2015-04-10 11:08
Title: Show the certificate chain of a local X509 file
Category: Blog
Tags: openssl

<div class="alert-info">
  <strong>UPDATE 2016/06/01:</strong> Improving the script by using pipe inside awk, thanks to <a href="#comment-2650059724">@ilatypov</a>.
</div>

When I play with X509 certificates I check that the certificate chain in the file is always complete and valid.

With `openssl s_client` we can see the chain and check its validity:

```
~ % openssl s_client -connect www.google.com:443 -CApath /etc/ssl/certs
CONNECTED(00000003)
depth=3 C = US, O = Equifax, OU = Equifax Secure Certificate Authority
verify return:1
depth=2 C = US, O = GeoTrust Inc., CN = GeoTrust Global CA
verify return:1
depth=1 C = US, O = Google Inc, CN = Google Internet Authority G2
verify return:1
depth=0 C = US, ST = California, L = Mountain View, O = Google Inc, CN = www.google.com
verify return:1
---
Certificate chain
 0 s:/C=US/ST=California/L=Mountain View/O=Google Inc/CN=www.google.com
   i:/C=US/O=Google Inc/CN=Google Internet Authority G2
 1 s:/C=US/O=Google Inc/CN=Google Internet Authority G2
   i:/C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
 2 s:/C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
   i:/C=US/O=Equifax/OU=Equifax Secure Certificate Authority
---
Server certificate
[snip]
    Verify return code: 0 (ok)
---

```

That's cool but... it works only with remote certificates. What to do with local files?

We have `openssl verify` to check the validity of the chain of a local file:

```
~ % openssl verify -untrusted google.crt google.crt
google.crt: OK
```
It says OK, cool but it's not very verbose: I don't see the chain like `openssl s_client` does and if I play with `openssl x509` it will only use the first certificate of the file.

The solution is to split all the certificates from the file and use `openssl x509` on each of them.

Someone already done a [oneliner to split certificates from a file](http://stackoverflow.com/questions/3777075/ssl-certificate-rejected-trying-to-access-github-over-https-behind-firewall/4454754#4454754) using `awk`. I initially based my script on it but [@ilatypov proposed a solution in comments](#comment-2650059724) that is far better as it does not rely on temporary files. Here is the updated script:

``` bash
#!/bin/bash

chain_pem="${1}"

if [[ ! -f "${chain_pem}" ]]; then
    echo "Usage: $0 BASE64_CERTIFICATE_CHAIN_FILE" >&2
    exit 1
fi

if ! openssl x509 -in "${chain_pem}" -noout 2>/dev/null ; then
    echo "$1 is not a certificate" >&2
    exit 1
fi

awk -F'\n' '
        BEGIN {
            showcert = "openssl x509 -noout -subject -issuer"
        }

        /-----BEGIN CERTIFICATE-----/ {
            printf "%2d: ", ind
        }

        {
            printf $0"\n" | showcert
        }

        /-----END CERTIFICATE-----/ {
            close(showcert)
            ind ++
        }
    ' "${chain_pem}"

echo
openssl verify -untrusted "${chain_pem}" "${chain_pem}"
```

Here is the output for the certificate file from _www.google.com_[ref]I've retrieved their certificate by using `openssl s_client` but by default it shows only the first certificate. Use the option `-showcerts` to see the complete chain[/ref] (_my script was saved as `ssl_chain.sh`_):
```
~ % ssl_chain.sh google.crt
 0: subject= /C=US/ST=California/L=Mountain View/O=Google Inc/CN=www.google.com
issuer= /C=US/O=Google Inc/CN=Google Internet Authority G2
 1: subject= /C=US/O=Google Inc/CN=Google Internet Authority G2
issuer= /C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
 2: subject= /C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
issuer= /C=US/O=Equifax/OU=Equifax Secure Certificate Authority

google.crt: OK
```

_Enjoy!_
