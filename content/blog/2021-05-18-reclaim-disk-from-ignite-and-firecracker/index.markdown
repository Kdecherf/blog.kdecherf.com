---
title: "Reclaim disk from Ignite and Firecracker"
date: 2021-05-18T20:19:19+02:00
tags:
- ignite
- firecracker
- containerd
---

A few weeks ago I checked my folders to reclaim some GB as my disk was running
low in free space. As I use Docker for developing and testing things I went over
the usual ritual of removing unused images, containers and volumes; however 7%
of the disk space was still in use in two containerd-related folders:
`io.containerd.snapshotter.v1.overlayfs/` and
`io.containerd.content.v1.content/`.

I started playing with `ctr`, a cli for interacting with the containerd daemon.

Listing namespaces with `ctr namespaces ls` returned 2 namespaces: `moby`
and `firecracker`. The first one is basically the containerd namespace used by Docker.
Which brings us to the latter one, `firecracker`.

[Firecracker][1] is a virtualization tool developed by Amazon to run fast microVM,
they use it for their Lambda and Fargate services. I tested it through another
tool, [Ignite][2], developed by Weaveworks. Ignite combines Firecracker with
containerd to instantly spawn virtual machines based on OCI images. I had tried
it a few months ago and mostly forgot about it[^1].

Well, now what's in this namespace?

`ctr --namespace firecracker images ls` will list all OCI images registered in
this namespace whereas `ctr --namespace firecracker containers` will list all
undeleted containers.

```
$ ctr --namespace firecracker images ls
REF                                        TYPE                                                      DIGEST                                                                  SIZE      PLATFORMS               LABELS
docker.io/exherbo/exherbo_ci:latest        application/vnd.docker.distribution.manifest.v2+json      sha256:507584f694530829f9446bddce2f1bf5afd9ed12cf85b34aa4b03c8d2d4a59b1 550.6 MiB linux/amd64             -
docker.io/hasufell/exherbo:latest          application/vnd.docker.distribution.manifest.v2+json      sha256:8417a0ff1d943b09d59acbe573f1fc8c472bbd28c9092e4a240097c3c201c9f5 747.0 MiB linux/amd64             -
docker.io/weaveworks/ignite-kernel:4.19.47 application/vnd.docker.distribution.manifest.v2+json      sha256:bfac196a3e66d798bde3e75fc93183bb19625b09b58f30f02afb69da22f52d05 13.4 MiB  linux/amd64             -
docker.io/weaveworks/ignite-ubuntu:latest  application/vnd.docker.distribution.manifest.v2+json      sha256:ad984fa5f6f2db55a0a48860d263a02a0f77aee3bbefa0d71648b4bc287ac13c 77.8 MiB  linux/amd64             -
docker.io/weaveworks/ignite:v0.6.1         application/vnd.docker.distribution.manifest.list.v2+json sha256:e07fd85ef209a249db1351f392077d88e14203962aa9f301a577117862af4989 17.1 MiB  linux/amd64,linux/arm64 -
```

```
$ ctr --namespace firecracker containers ls | grep "ignite-"
ignite-1b0f98951950bb14    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-4a94ec9a9636c8d3    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-4e63fb439144667a    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-626c6b82ed3ce267    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-98d3050bdc61ae1d    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-af49dbf0e3eb1411    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-b4ea5e62b51db0a3    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-ccf2fb95d92137f9    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-e8c665ef48581261    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-eb773b544ea20058    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-fb5713506704e2c2    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
ignite-fd6afd1c080ca3d4    docker.io/weaveworks/ignite:v0.6.1    io.containerd.runc.v1
```

At that time it's important to note that the ignite cli didn't show anything.
Thus we can feed these ids to `ctr --namespace firecracker containers rm` and
`ctr --namespace firecracker images rm` to remove containers and images,
respectively.

Glad to see you again, free space.

[1]: https://github.com/firecracker-microvm/firecracker/
[2]: https://github.com/weaveworks/ignite

[^1]: Those tools are pretty neat though
