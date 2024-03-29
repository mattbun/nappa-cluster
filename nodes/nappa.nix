{ config, pkgs, lib, ... }:

{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/matt/nappa/nodes/nappa.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nappa";
    hostId = "b4b9e863";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  # Publish this server and its address on the network
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = false;
  services.xserver.displayManager.startx.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    # shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    curl
    git
    helm # synthesizer
    kubectl
    kubernetes-helm
    k9s
    screen
    vim
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # rpi style
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking.defaultGateway = "192.168.1.1";
  networking.interfaces.enp4s0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "192.168.2.1";
      prefixLength = 24;
    }];
  };

  services.dnsmasq = {
    enable = true;
    extraConfig = ''
      interface=enp4s0
      dhcp-range=192.168.2.10,192.168.2.250,255.255.255.0,12h
    '';
  };

  networking.firewall = {
    enable = true;
    extraCommands = ''
      iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
    '';
    trustedInterfaces = [ "eno1" "enp4s0" ];
    allowedTCPPortRanges = [{ from = 1; to = 65535; }];
    allowedUDPPortRanges = [{ from = 1; to = 65535; }];
    #allowedTCPPorts = [ 6443 ];
    #allowedUDPPorts = [ 67 6443 ];
  };

  # k3s
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--advertise-address=192.168.2.1 --node-ip=192.168.2.1 --node-external-ip=192.168.1.4 --flannel-backend=host-gw --flannel-iface=enp4s0";
  };

  # Give nappa the ability to build images for raspberry pis
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" "arm-linux" ];

  # Mount extra partition and use it as an NFS share
  fileSystems."/nfs" = {
    device = "/dev/disk/by-uuid/c4be327c-5c81-4600-9177-cd7c19b0f29e";
    fsType = "ext4";
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /nfs 192.168.2.0/24(rw,no_subtree_check,sync,no_wdelay,insecure,no_root_squash)
    '';
  };

  # Periodically clean up old nix generations
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 90d";

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
