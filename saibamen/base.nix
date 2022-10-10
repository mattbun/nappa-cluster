{ pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];

  # TODO build to somewhere other than ./result
  sdImage = {
    compressImage = false;

    # TODO wish I could get the hostname in here somehow
    imageName = "nixos-sd-image-saibaman.img";
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

  system.stateVersion = "22.05";
}
