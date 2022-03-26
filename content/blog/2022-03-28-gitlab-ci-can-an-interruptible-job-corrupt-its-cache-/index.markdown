---
title: "GitLab CI: can an interruptible job corrupt its cache?"
date: 2022-03-28T16:22:19+02:00
tags:
- gitlab
---

We had a question at work about the `interruptible` keyword[^1] in Gitlab CI
jobs. It lets Gitlab automatically cancel pipelines[^2] if a more recent commit
triggers a new pipeline for the same branch.

On one of our projects we have an early job in the pipeline which builds a
cache of dependencies to speed up the other jobs. As the resulting cache may be
shared between different pipelines (_thanks to the lockfile key feature_), our
concern was: can we safely make this job interruptible without risking cache
corruption?

Unfortunately the GitLab documentation is unclear about what happens to the
different job phases when a cancel is received, so I decided to find the answer
by digging into the gitlab-runner source code. After struggling for hours
trying to understand its codebase, I decided to take a more offensive approach
by causing a corruption.

I spawned a dummy project, a S3 bucket and a gitlab runner on a Scaleway
instance with the _docker_ executor. If you want to try it, here is the
_docker-compose_ file:

``` yaml
version: '3.3'

services:
  runner:
    image: gitlab/gitlab-runner:v14.9.1
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      CI_SERVER_URL: 'https://gitlab.com'
      CACHE_TYPE: 's3'
      CACHE_SHARED: 'true'
      CACHE_S3_BUCKET_NAME: 'sandbox-gitlab-runner-cache'
      CACHE_S3_SERVER_ADDRESS: 'sandbox-gitlab-runner-cache.s3.fr-par.scw.cloud'
      CACHE_S3_BUCKET_LOCATION: 'fr-par'
      CACHE_S3_ACCESS_KEY: '…'
      CACHE_S3_SECRET_KEY: '…'
      REGISTER_NON_INTERACTIVE: 'true'
      REGISTER_RUN_UNTAGGED: 'true'
      RUNNER_EXECUTOR: 'docker'
      DOCKER_IMAGE: 'ubuntu:20.04'
      DOCKER_PRIVILEGED: 'false'
      DOCKER_DISABLE_CACHE: 'true'
      REGISTRATION_TOKEN: '…'
    entrypoint: |
      bash -c 'gitlab-runner register && sed -i -e "1s/^/log_level = \"debug\"\n/" /etc/gitlab-runner/config.toml && gitlab-runner run'
```

Then we create the following `.gitlab-ci.yml` configuration file:

``` yaml
stages:
  - check
  - push

checksum:
  stage: check
  before_script:
    - mkdir -p .cache
  script:
    - find .cache -type f -exec sha1sum {} \;
  interruptible: true
  cache:
    paths:
      - .cache
    policy: pull

push:
  stage: push
  before_script:
    - mkdir -p .cache
  script:
    - find .cache -type f -exec sha1sum {} \;
    - dd if=/dev/urandom of=.cache/${CI_PIPELINE_ID} bs=1M count=64
    - find .cache -type f -exec sha1sum {} \;
  interruptible: true
  cache:
    paths:
      - .cache
```

In short, this file will create a pipeline with two jobs: the first will pull
the cache and print a SHA-1 sum of all its files while the latter will create a
new 64M file and add it to the cache. It will also print a SHA-1 sum of the
files in order to compare it with the next pipeline.

We can easily trigger pipeline auto-cancel by pushing empty commits, using `git
commit --allow-empty -m "Empty commit" && git push`.

We can also make it easier to cancel a pipeline during the _cache-archiver_
phase by slowing down the upload speed (_e.g. 8 Mbps_) with the help of _tc_:

```
tc qdisc add dev ens2 root handle 1: htb default 12
tc class add dev ens2 parent 1: classid 1:10 htb rate 8192kbps
tc filter add dev ens2 protocol ip parent 1:0 prio 1 u32 match ip dst <bucket ip> flowid 1:10
```

We let some pipelines run completely to have a few files in the cache:

```
$ find .cache -type f -exec sha1sum {} \;
99748c2e426216f712baa9ef07e108aca21b4d76  .cache/501872479
f30f3d9ed363e397d64a774c7d501bd3eef7a8ad  .cache/501873411
c497406e883e190876c6d89fb0bc42a85ac1c196  .cache/501869952
```

Then we cancel a running job during the upload phase; the script phase may
produce[^3] an output like this:

```
$ find .cache -type f -exec sha1sum {} \;
dd2d1d2ecf655ba2a3223cdba413c5ed4f8cbb18  .cache/501874243
99748c2e426216f712baa9ef07e108aca21b4d76  .cache/501872479
f30f3d9ed363e397d64a774c7d501bd3eef7a8ad  .cache/501873411
c497406e883e190876c6d89fb0bc42a85ac1c196  .cache/501869952
```

This output indicates that a fourth file was intended to integrate the cache
archive.

Finally we create a last pipeline to run the _check_ job; it should show that
the archive does not contain the fourth file (_`.cache/501874243` here_).
Runner debug logs show that it waits the end of the upload phase to cancel it
but does not seem to "commit" it on the distributed cache.

This tends to show that cancelling a job during the `cache-archiver` phase does
not corrupt the cache.

As a side note I would be more than happy to learn more about how this cancel
mechanism works if you are familiar with the _gitlab-runner_ codebase.

_Enjoy!_

[^1]: https://docs.gitlab.com/ee/ci/yaml/index.html#interruptible
[^2]: https://docs.gitlab.com/ee/ci/pipelines/settings.html#auto-cancel-redundant-pipelines
[^3]: Logs are not always uploaded to the GitLab server when jobs are cancelled
