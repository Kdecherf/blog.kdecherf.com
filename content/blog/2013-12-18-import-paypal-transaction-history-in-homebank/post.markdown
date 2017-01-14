Title: Import Paypal transaction history in HomeBank
Date: 2013-12-18 15:08
Category: Blog

<div class="alert-info">
  <strong>UPDATE 2014/03/16:</strong> updated sed line to remove the header of initial csv file.
</div>

Wow, it's been a long time since my last post. Few days ago I found a cool free and open-source (_and cross-platform_) software for personal accounting: [HomeBank](http://homebank.free.fr).

This tool works well but the 'Import' feature requests a "proprietary" CSV format described [here](http://homebank.free.fr/help/misc-csvformat.html). As I have a Paypal account for e-shopping I wanted to track these transactions too. So I made a tiny gawk script to convert a Paypal transaction history into the HomeBank CSV format.

The best export format from Paypal will be the "complete transaction history" comma-delimited CSV because we need all currency conversion transactions. This export has more than 35 fields and some duplicate transactions for currency conversion and pre-authorization, so we need to do some cleaning.

``` awk
BEGIN {
   currency="EUR"
   ignore="Carte bancaire"
   i=0
}
{
   if ($4 != ignore) {
      if ($31 == "") {
         ref[$13] = $0
      }
      lines[i] = $0
      i++
   }
}
END {
   for (pos in lines) {
      split(lines[pos], line, ";")
      if (line[7] == currency) {
         if (line[31] in ref) {
            split(ref[line[31]],newl,";")
            info = ""
            if (newl[7] != currency) {
               info = sprintf("%s %s", newl[7], newl[10])
            }
            printf ("%s;0;%s;%s;%s;%s;;\n", newl[1], info, newl[4], newl[16], line[10])
            rep[line[31]] = line[13]
         } else {
            if (rep[line[13]] == "") {
               printf ("%s;0;;%s;%s;%s;;\n", line[1], line[4], line[16], line[10])
            }
         }
      }
   }
}
```

HomeBank does not support multi-currency so this script will take all foreign currency transactions and replace the price with the converted amount. The original currency and amount are added in the ``info`` field.  
The currency conversion is possible because Paypal will add two transaction lines linked to the original transaction by its ID (_31st field_).

The second particular point about this script is the variable `ignore`. _Carte bancaire_ (_"Debit card" in my locale_) refers to a transfer between my Paypal account and my main bank account, I don't need these transactions as I create an _Internal transfer_ directly into HomeBank using the debit card transaction on my bank account. A transaction with the type _Internal transfer_ will automatically add a linked transaction into the target account, and voilà.

We need some processing of the Paypal CSV file before using the gawk script: we need to remove ``"``, replace ``,`` with ``;`` and reorder the date according to the destination format, it is done with `sed`.

Here is the oneliner to convert the CSV file (_with the previous script saved in the same folder as `paypal-homebank.awk`_):

``` bash
sed -e 's/",/";/g' -e 's/"//g' -e "s@\([0-9]\{2\}\)/\([0-9]\{2\}\)/\([0-9]\{4\}\)@\1-\2-\3@" -e "1d" paypal-export.csv | awk -F';' -f paypal-homebank.awk > import.csv
```

_Enjoy!_

_Note: this tool is now available for Exherbo users using the package ``app-office/homebank``._
