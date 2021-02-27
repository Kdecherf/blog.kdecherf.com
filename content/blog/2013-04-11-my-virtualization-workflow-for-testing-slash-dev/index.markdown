Title: My virtualization workflow for testing/dev
Date: 2013-04-11 19:45:00
Category: Blog
Slug: my-virtualization-workflow-for-testing-slash-dev

I work all the day with virtual machines for packaging and testing tools at Clever Cloud. Since I am a KVM lover, I began with libvirt to easily manage my virtual machines but using XML files and virt-manager made me crazy.

For this reason and others (*eg. deleting some dependencies on my system*) I decided to write tiny bash scripts to quickly boot virtual machines and manage a simple network without libvirt.

My workflow is quite simple: I have some template images (*pre-installed systems*) for several systems (*eg. Exherbo, Ubuntu and CentOS*) and I make a copy of these images to create a new machine and quickly make my stuff.
And as I have no complex needs for the networking, I use a little NAT-ed private bridge with a /24 network and a DHCP server.

Otherwise systemd has a really interesting feature: `systemd-nspawn` which let you boot virtual machines in container mode (*share kernel and resources of the host*). Be careful though, it works only with systemd-enabled machines.

So why using two virtualization modes? systemd-nspawn gives me a prompt in only 5 seconds which is helpful when I need to test very quickly a patch or a software but don't want to have a full virtual environment. Just keep in mind that in this mode all resources are shared with the host (*no limitation, no 'jail'*): CPU, memory and also network so you can't do same things than with KVM. For the rest, there is KVM.

Several people were interested in my scripts so yesterday I merged and rewrote some parts to create `birsh` (as opposed to `virsh`).

This tool is simple, just type `birsh start php -m 512` to boot a virtual machine with 512MB of memory using the disk _php.qcow2_. Or you can also use `birsh nspawn php` to boot the same disk with `systemd-nspawn`.

You can connect to the serial console of a KVM machine with `birsh serial php` (*eg. for the php machine*).

This tool is not so beautiful and it lacks features like disk management and removable media boot but it works and I will improve it in the future ;-)

Link: [https://github.com/Kdecherf/birsh](https://github.com/Kdecherf/birsh)

![birsh]({attach}birsh.jpg)
{: .image}

_Enjoy!_
