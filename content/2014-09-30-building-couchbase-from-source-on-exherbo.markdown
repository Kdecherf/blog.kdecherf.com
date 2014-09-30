Title: Building Couchbase from source on Exherbo
Date: 2014-09-30 16:24
Category: Tips
Tags: exherbo

Hey this is my first post of the year, happy new ye... oh wait. As of now Couchbase can't be packaged in Paludis/Exherbo due to the lack of support of _git-repo_. So if we want to play with this soft we need to build it manually from source (_I hate unpacking .deb or .rpm files on my distro_).

First of all, we need to add some repositories for the dependencies:

``` bash
$ cave resolve repository/{desktop,sardemff7,CleverCloud,malinka} -x1
```

Next, we will install all the required dependencies:

``` bash
$ cave resolve app-arch/snappy dev-libs/icu =dev-lang/erlang-16.03.1 dev-libs/v8 sys-apps/repo -x
```

We fix the version of Erlang to 16.03.1 (_R16B03-1_) as it is the recommended version by the Couchbase team. There is also a good read about the stability of Erlang R14, R15 and R16[1].


Starting at `rel-2.2.1.xml`, _memcached_ requires _tcmalloc_ from the Google's project _gperftools_. Just install it:

``` bash
$ cave resolve repository/alip -x1
$ cave resolve =gperftools-2.1 -x
```

There are breaking changes in _gperftools_ 2.2.1 so we stay on the version 2.1.

Now you can build Couchbase without error using the usual method:

``` bash
$ repo init -u git://github.com/couchbase/manifest.git -m rel-2.5.1.xml
$ repo sync
$ make
```

_Enjoy!_

References:

[1] [https://gist.github.com/chewbranca/07d9a6eed3da7b490b47](https://gist.github.com/chewbranca/07d9a6eed3da7b490b47)

