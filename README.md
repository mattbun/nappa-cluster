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

2. Copy the config at `nappa/etc/nixos/configuration.nix` to `/etc/nixos/configuration.nix`

    ```shell
    sudo cp ./nappa/etc/nixos/configuration.nix /etc/nixos/configuration.nix
    ```

3. `sudo nixos-rebuild switch`

## Installation (saibamen)

[See README in saibamen directory.](https://github.com/mattbun/nappa/blob/main/saibamen/README.md)
