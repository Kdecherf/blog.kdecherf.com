---
title: "Chained SSH connection to a virtual machine via its host"
date: 2012-10-31T19:41:00+01:00
tags:
- ssh
---

After some weeks without any post, I'm back with a tip about chained SSH connection in a highly virtualized world.

I present you in this tip pros and cons of 4 different ways to connect to a virtual machine using SSH.
<!--more-->


### Manual connection from the host

It's the basic way to connect to a virtual machine: by hand from its host but it costs one more command than other methods.

``` shell-session
kdecherf@home ~ % ssh root@my.server.example.org
Last login: Sun Oct 28 18:36:24 2012 from my.home.example.org
server ~ # ssh 10.0.0.2
Last login: Sun Oct 28 18:46:48 2012 from my.server.example.org
virtual ~ #
```

### Automatic login using authorized\_keys file

When you use keys to login to your servers, you can specify a command to be executed when a specific key is used. So you can chain SSH connection like this:

```
command="/usr/bin/ssh root@yourhost",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-rsa yourrsapublickey mykeycomment
```

So when you connect to the server with this key, you will be automatically logged to the virtual machine:

``` shell-session
kdecherf@home ~ % ssh root@my.server.example.org
Last login: Sun Oct 28 18:35:18 2012 from my.server.example.org
virtual ~ #
```

And you will be disconnected from the host when you log out.

**Pros:**

 * You can use one public key for each virtual machine (_it can quickly become a con_)
 * It's easy to use and maintain

**Cons:**

 * The virtual machine will only see that the connection comes from the host and not from your computer
 * The virtual machine is not able to use your public key for the connection but will use the key of the host's user (_or will ask you a password if you don't use any key_)
 * The ``command`` argument of ``ssh`` will fail


### Port redirection using iptables

You can also use ``iptables`` to redirect one port of the host to the SSH server of the virtual server.

``` shell-session
iptables -t nat -A PREROUTING -m tcp -p tcp --dport 2222 -j DNAT --to-destination 10.0.0.2:22
```

``` shell-session
kdecherf@home ~ % ssh root@my.server.example.org -p 2222
Last login: Sun Oct 28 18:59:47 2012 from my.server.example.org
virtual ~ #
```

**Pros:**

 * The virtual machine sees the origin of the connection
 * The virtual machine is able to use your public key for this connection
 * It's the only method that doesn't need authentication on the host to access to the virtual machine

**Cons:**

 * You will consume one port per virtual machine
 * The SSH server of each virtual machine is exposed to the ruthless world


### Automatic login using sshd\_config file

The last method is to use the SSH server (_OpenSSH here_) configuration file of the host to chain the connection to the virtual machine:

``` text
Match User myvirtualuser
         ForceCommand /usr/bin/ssh root@10.0.0.2
         AllowTCPForwarding no
         X11Forwarding no
```

And after the restart of openssh-server:

``` shell-session
kdecherf@home ~ % ssh myvirtualuser@my.server.example.org
Last login: Sun Oct 28 19:13:59 2012 from my.server.example.org
virtual ~ #
```

**Pros:**

 * _I've not found any pro for this method_

**Cons:**

 * One system user on the host for each virtual machine
 * It's hard to maintain because you need to restart the host SSH server on each change
 * And same cons than *Automatic login using authorized\_keys file*


I personally prefer the second solution when I have only few virtual machines to manage :)

_Enjoy it!_

**UPDATE**

OpenSSH now provides [a new feature](http://www.gossamer-threads.com/lists/openssh/dev/54584): **AuthorizedKeysCommand** which allows us to make a script to automatically generate public keys listing for a given user at the login.
