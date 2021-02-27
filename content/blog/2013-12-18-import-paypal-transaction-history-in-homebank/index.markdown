Title: Import Paypal transaction history in HomeBank
Date: 2013-12-18 15:08
Category: Blog
Tags: homebank, paypal

<div class="alert-info">
  <strong>UPDATE 2017/06/11:</strong> replaced sed call with awk and refactored
  code. Fixed field changes and added email addresses in memo, thanks to <a href="http://www.linkedin.com/in/christopherslee/">Chris Slee</a>.
</div>
<div class="alert-info">
  <strong>UPDATE 2014/03/16:</strong> updated sed line to remove the header of initial csv file.
</div>

Wow, it's been a long time since my last post. Few days ago I found a cool free and open-source (_and cross-platform_) software for personal accounting: [HomeBank](http://homebank.free.fr).

This tool works well but the 'Import' feature requests a "proprietary" CSV format described [here](http://homebank.free.fr/help/misc-csvformat.html). As I have a Paypal account for e-shopping I wanted to track these transactions too. So I made a tiny gawk script to convert a Paypal transaction history into the HomeBank CSV format.

The best export format from Paypal will be the "complete transaction history" comma-delimited CSV because we need all currency conversion transactions. This export has more than 35 fields and some duplicate transactions for currency conversion and pre-authorization, so we need to do some cleaning.

``` awk
# in_array: check if el is in array arr
function in_array(arr, el) {
   el = clean_line(el)
   for (cur in arr) {
      if (el == arr[cur]) {
         return 1;
      }
   }
   return 0;
}
# extract: extract and send clean values from el to _line
function extract(el, _line) {
   patsplit(el, _line, FPAT)
   for (x in _line) {
      _line[x] = clean_line(_line[x])
   }
}
# clean_line: remove quotes from string val
function clean_line(val) {
   return gensub(FPAT, "\\1", "g", val)
}
# get_summary: replace object with email if empty
function get_summary(el) {
   if (el[16] != "") { # 16: Object title
      return el[16]
   } else {
      if (el[10] < 0) { # 10: Amount
         return sprintf("To %s", el[12]) # 12: Recipient address
      } else {
         return sprintf("From %s", el[11]) # 11: Sender address
      }
   }
}
BEGIN {
   FPAT="\"([^\"]*)\""
   currency="EUR"
   excludeNameStr="Compte bancaire,Carte bancaire"
   excludeTypeStr="Autorisation,Suspension temporaire"
   split(excludeNameStr,excludeName,",")
   split(excludeTypeStr,excludeType,",")
   i=0
}
{
   if (NR != 1) {
      if (!in_array(excludeName, $4) &&
            !in_array(excludeType, $5)) {
         if (clean_line($29) == "") { # 29: Parent transaction
            ref[clean_line($13)] = $0 # 13: Transaction number
         }
         lines[i] = $0
         i++
      }
   }
}
END {
   for (pos in lines) {
      extract(lines[pos], line)
      if (line[7] == currency) { # 7: Currency
         if (line[29] in ref) { # 29: Parent transaction
            extract(ref[line[29]], newl)
            info = ""
            if (newl[7] != currency) {
               info = sprintf("%s %s", newl[7], newl[10]) # 10: Amount
            }
            summary = get_summary(newl)
            # Date;0;{info};Name;{summary};Amount
            printf ("%s;0;%s;%s;%s;%s;;\n", newl[1], info, newl[4], summary, line[10])
            rep[line[29]] = line[13]
         } else {
            if (rep[line[13]] == "") {
               summary = get_summary(line)
               # Date;0;;Name;{summary};Amount
               printf ("%s;0;;%s;%s;%s;;\n", line[1], line[4], summary, line[10])
            }
         }
      }
   }
}
```

Simply execute the following command to convert your file:

``` bash
awk -f /your/path/to/paypal-homebank.awk paypal-file.csv > converted-paypal-file.csv
```

Few notes about this script:

HomeBank does not support multi-currency so this script will take all foreign currency transactions and replace the price with the converted amount. The original currency and amount are added in the ``info`` field.  
The currency conversion is possible because Paypal adds two transaction lines linked to the original transaction by its ID (_29st field_).

The second particular point about this script is the variable `ignore`. _Carte bancaire_ (_"Debit card" in my locale_) refers to a transfer between my Paypal account and my main bank account, I don't need these transactions as I create an _Internal transfer_ directly into HomeBank using the debit card transaction on my bank account. A transaction with the type _Internal transfer_ will automatically add a linked transaction into the target account, and voilà.

The function `get_summary` will extract a text line for the memo field of HomeBank transaction. If there is no object title, we use sender and recipient email addresses respectively for incoming and outgoing transactions.

_Enjoy!_

_Note: this tool is now available for Exherbo users using the package ``app-office/homebank``._
