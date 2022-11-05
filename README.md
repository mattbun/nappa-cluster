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

2. Run `nixos-rebuild switch`, but be sure to include the path to `nappa.nix`

    ```shell
    sudo nixos-rebuild switch -I nixos-config=/home/matt/nappa/nodes/nappa.nix`
    ```

Subsequent calls to `nixos-rebuild switch` don't require `nixos-config` to be specified:

```shell
sudo nixos-rebuild switch
```

## Installation (saibamen)

The nix configurations at `nodes/saibamanX.nix` can be used to build sd card images.

1. Build the image

    ```shell
    nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage --argstr system aarch64-linux -I nixos-config=./saibaman1.nix
    ```

2. Install the image on an SD card

    ```shell
     sudo dd if=./result/sd-image/nixos-sd-image-22.05.1700.365e1b3a859-aarch64-linux.img of=/dev/sdb bs=4096 conv=fsync status=progress
    ```

3. Put the SD card into the raspberry pi and start it up!

4. It'll take a moment for it to start up, but once it's up and running change the password

    ```shell
    # initial password is 'changeme'
    ssh matt@192.168.2.X
    passwd
    ```

5. The agent node should get picked up by the k3s server node automatically
