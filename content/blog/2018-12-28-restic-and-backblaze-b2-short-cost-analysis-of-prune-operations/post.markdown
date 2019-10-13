Title: restic and Backblaze B2: short cost analysis of prune operations
Category: Blog
Tags: backblaze,restic
Date: 2018-12-28 15:17:47

<div class="alert-info">
  <strong>UDPATE 2019/10/13:</strong> added a third prune example with a larger
  repository
</div>

After Crashplan shutted down its consumer backup plan I moved to [restic][1]
and [Backblaze B2][2] for backing up my computers and servers. restic provides
a really powerful deduplication system that allows you to keep costs quite low.

The downside of this method is that pruning obsolete backups may be slow and
costly as it usually needs to rewrite a lot of data on the remote endpoint.

In the past months I pruned a repository twice using the following command:

``` bash
restic forget -n --keep-daily 7 --keep-weekly 16 --keep-monthly 8
```

This command will basically keep the 7 last daily updates, the 16 last weekly
snapshots (_3 months worth of weekly snaps_) and the 8 last monthly snaps. The
`-n` is for _dry-run_, execute the command without it when you're sure of what
you want.

After this operation you must `restic prune` to actually remove the snapshots
marked for deletion. This operation on one of my repositories[^1] gave me these
numbers:

## First prune

Before the prune, the bucket held 29 snapshots for 12k+ stored files and
occupied 64GB of space. The average snap was composed of roughly 200k files for
45GB.

The forget operation marked 19 snapshots out of 29 for deletion. The prune:

- Took 160 minutes
- Freed a little more than 7GB
- Downloaded ~7GB of data (_billed for $0.06 by Backblaze_)
- Made 33k+ class B transactions (_billed for $0.01_)
- Emitted 5.4GB of data

This prune cost is estimated at **$0.07** and allowed me to save **$0.035 per
month**.

_This prune operation is basically profitable after 2 months._

## Second prune

At the time of the second prune, the bucket was a little heavier. It held 53
snapshots for 16k+ stored files and occupied 81.5GB.  The last snapshot weighed
49GB.

The forget operation marked 29 snapshots for deletion and the prune operation:

- Took 130 minutes
- Freed 13GB
- Downloaded 4GB of data (_billed for $0.03_)
- Made 38k+ class B transactions (_billed for $0.01_)
- Emitted 1.6GB of data

This prune was cheaper than the first by costing roughly **$0.04** but it
allowed me to save **$0.07** per month.

## Another system

I've finally done a prune on my largest repository, which handles around 1TB of
data for 85k+ files. Before the prune the storage use was approximately 1.15TB.
This repository handles a lot of files with infrequent to non-existent updates
and backups are mostly for newly added files; But a few months ago I removed
several dozens of GB of data and I never pruned it until today.

The forget operation marked 18 snapshots for deletion and the prune operation:

- Took 39 hours[^2]
- Freed 100+GB
- Downloaded 120+GB of data (_billed for $1.20_)
- Made 540k+ class B transactions (_billed for $0.19_)

This prune costed roughly **$1.39** and allowed me to save **$0.50** per month.

These numbers may hardly apply to your repositories and/or use cases but it
should give you a general idea of what costs to expect when pruning a restic
repository.

On a side note I used the following command to track network statistics:

``` bash
iftop -f 'port https and not ip6 and (net 162.244.56.0/21 or net 206.190.208.0/21)'
```

The Backblaze IPv4 ranges can be found here:
[https://help.backblaze.com/hc/en-us/articles/217664588-Backblaze-IP-Address-List](https://help.backblaze.com/hc/en-us/articles/217664588-Backblaze-IP-Address-List).

_Enjoy!_

[1]: https://restic.net/
[2]: https://www.backblaze.com/b2/cloud-storage.html

[^1]: This repository is not the larger that I have but I wanted to give a try
  with a small one before playing with the other repositories.
[^2]: I used `-o b2.connections=20` for this prune operation, I don't know if it
  had a impact on overall duration.
