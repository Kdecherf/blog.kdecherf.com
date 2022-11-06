---
title: "Having fun with RFC 1342 and \"Q\" encoded-words in mail headers"
date: 2022-11-14T15:05:00+01:00
tags:
- smtp
- rfc
---

A few months ago I went to investigate why some automated emails from our
platform eventually ended into the spam folder for a specific user.

While investigating we've finally found the peculiar case of reproduction. Were
marked as spam emails meeting all these criterias:
- They are sent to recipients hosted on Yahoo-owned services (_e.g. Yahoo Mail_)
- They contain both a `@` and a non-ASCII character in the display name of the sender

Using `Foo @® Bar <something@example.com>` as the sender, our library sent an
email with the following From header:

```
From: =?utf-8?Q?Foo=20@=C2=AE=20Bar?= <something@example.com>
```

Wait, what's this format? We'll see in a moment because right now doing more
tests makes me notice that the issue can also be triggered by using this
display name as the recipient. Let's see how some well-known providers handle
this.

The next test is to send an email from Gmail and FastMail with a crafted
display name and see if it lands in the inbox of our Yahoo Mail user. For that,
I'll use the following text: `Kévin @ Blah —` (_last char being U+2014 EM
DASH_).

In both cases the email was correctly delivered to the inbox. Let's check what
was put in the To header.

First, what did FastMail send?

```
To: =?UTF-8?Q?K=C3=A9vin_=40_Blah_=E2=80=94?= <kdecherf@ymail.com>
```

And what did Gmail send?

```
To: =?UTF-8?B?S8OpdmluIEAgQmxhaCDigJQ=?= <something@ymail.com>
```

Wait, what's this? Have a seat and let me introduce you to RFC 1342[^1] _aka_
_"Representation of Non-ASCII Text in Internet Message Headers"_.

Here is a short summary of this standard:

> RFC 1341 describes a mechanism for denoting textual body parts which are
> coded in various character sets, as well as methods for encoding such body
> parts as sequences of printable ASCII characters.
>
> This memo describes similar techniques to allow the encoding of non-ASCII
> text in various portions of a RFC 822[^2] message header, in a manner which
> is unlikely to confuse existing message handling software

It defines two different encodings: "Q" for 'Quoted-printable' encoding and "B"
for Base 64 encoding.

Now, we know that Gmail is using "B" encoded-words, thus we'll ignore it for the
rest of our investigation.

Let's focus on the difference between what FastMail actually sent and what we
sent: the `@`. FastMail encoded it in the display name as part of the whole "Q"
encoded-phrase using `=40` whereas we've let the `@` untouched.

Interesting.

What happens if we remove the non-ASCII character from the display name?
Sending an email through our library results in the following encoding, without
deliverability issue:

```
From: "Foo @ Bar" <address...>
```

If we summarize, our library handles From/To header depending on the presence
of non-ASCII characters:
- If present, "Q" encode the phrase
- Else, quote the phrase

Can a plain `@` in a q encoded-word cause issue? What says the RFC?

Section _"Use of encoded-words in message headers"_[^1] states:

> ["Q" encoded-words can be used] As a replacement for a "word" entity within a
> "phrase", for example, one that precedes an address in a From, To, or Cc
> header.  The EBNF definition for phrase from RFC 822 thus becomes:
>
>   phrase = 1*(encoded-word / word)
>
> In this case the set of characters that may be used in a "Q"-encoded
> encoded-word is restricted to: <upper and lower case ASCII letters, decimal
> digits, "!", "*", "+", "-", "/", "=", and "_" (underscore, ASCII 95.)>.

That being said, `@` is not considered as an accepted character in our case and
must be encoded as part of the q encoded-word.

So it looks like there was a bug.

And here we are, it is the end of yet another day reading a RFC; and I must
admit that I still enjoy learning weird things from thirty years old
standards[^3].

[^1]: _"Representation of Non-ASCII Text in Internet Message Headers"_ https://datatracker.ietf.org/doc/html/rfc1342
[^2]: _"Standard for the format of ARPA Internet Text Message"_ https://datatracker.ietf.org/doc/html/rfc822
[^3]: Shit, I'm not even younger than this one
