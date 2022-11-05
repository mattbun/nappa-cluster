# Nappa

Configuration for the nappa k3s cluster.

## Overview

```
nappa (k8s control plane, serves as network gateway for saibamen)
 ├─saibaman1
 └─saibaman2
```

## Installation (nappa)

Install NixOS, then

1. Clone this repo to `/home/matt/nappa`

2. `sudo nixos-rebuild switch -I nixos-config=/home/matt/nappa/nappa/nappa.nix`

Subsequent calls to `nixos-rebuild switch` don't require `nixos-config` to be specified:

```shell
sudo nixos-rebuild switch
```

## Installation (saibamen)

[See README in saibamen directory.](https://github.com/mattbun/nappa/blob/main/saibamen/README.md)
