{ pkgs, lib, config, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];

  options.saibaman = {
    name = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    networking.hostName = config.saibaman.name;

    # TODO build to somewhere other than ./result
    sdImage = {
      compressImage = false;
      imageName = "nixos-sd-image-${config.saibaman.name}.img";
    };

    # put your own configuration here, for example ssh keys:
    users.users.matt = {
      isNormalUser = true;
      home = "/home/matt";
      extraGroups = [ "wheel" ];
      initialPassword = "changeme";

      # TODO this could be cool if it grabbed the key from nappa
      # openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3Nza... alice@foobar" ];
    };

    # networking.hostName = hostName;

    services = {
      sshd.enable = true;

      k3s = {
        enable = true;
        role = "agent";
        serverAddr = "https://192.168.2.1:6443";

        # TODO
        token = "...";
        # TODO this would be cool, but this file isn't accessible unless you're root
        # token = builtins.readFile "/var/lib/rancher/k3s/server/node-token"
      };
    };

    environment.systemPackages = with pkgs; [
      nfs-utils # Required for nfs-subdir-external-provisioner
    ];

    networking.firewall.enable = false;

    # Override default nixos-config path to keep file names the same between /etc and this repo
    nix.nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/${config.saibaman.name}.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    # Put a copy of this configuration in /etc/nixos
    environment.etc."nixos/saibaman_base.nix" = {
      mode = "0660";
      gid = config.users.groups.wheel.gid;
      text = builtins.readFile (./. + "/saibaman_base.nix");
    };
    environment.etc."nixos/${config.saibaman.name}.nix" = {
      mode = "0660";
      gid = config.users.groups.wheel.gid;
      text = builtins.readFile (./. + "/${config.saibaman.name}.nix");
    };

    # Periodically clean up old nix generations
    nix.gc.automatic = true;
    nix.gc.options = "--delete-older-than 90d";

    system.stateVersion = "22.05";
  };
}
