# saibamen

![saibamen](https://static.wikia.nocookie.net/dragonball/images/1/1c/Saibamen_Anime.png/revision/latest/scale-to-width-down/350?cb=20210506052810)

NixOS configs for "saibaman" k3s agent nodes.

## Installation

You can use the configurations here to build sd card images.

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
