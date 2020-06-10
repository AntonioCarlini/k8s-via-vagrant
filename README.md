# Provision a Kubernetes Cluster

----
## Purpose

I needed to build a kubernetes cluster easily and reliably on my local system and this repository is the result.

Vagrant and VirtualBox need to be installed and configured.

## Issues

There are still a few things to iron out, but the basic functionality is present.

* Nothing checks that the specified IP addresses are actually part of the specified subnet.

* Knowledge of how to build the hostnames is scattered over a number of places.

* The temporary cluster hosts file is not deleted (deleting it seems to upset vagrant).

* It would be more conveneint to determine the main host network interface automatically.
