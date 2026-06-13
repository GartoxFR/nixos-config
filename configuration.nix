# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" "nfs" ];

  services.rpcbind.enable = true;

  services.blueman.enable = true;

  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "192.168.204.201:/mnt/pve/hdd";
    where = "/mnt/hdd";
  }];
  systemd.automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
          TimeoutIdleSec = "600";
      };
      where = "/mnt/hdd";
  }];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.gc = {
    automatic = false;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  networking.hostName = "laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireguard.enable = true;
  networking.firewall.checkReversePath = false;

  # Setup for port forwarding with raspberry pi
  # boot.kernel.sysctl = {
  #   "net.ipv4.conf.all.forwarding" = true;
  # };
  # networking.nat.enable = true;
  # networking.firewall.extraCommands = "iptables -t nat -A POSTROUTING -o enp7s0 -j MASQUERADE";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  # };

  programs.fuse = {
    userAllowOther = true;
  };

  # programs.direnv = {
  #   enable = true;
  #   silent = true;
  # };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.udisks2.enable = true;

  # services.flatpak.enable = true;

  hardware.graphics = {
    enable = true;
  };

  # hardware.opentabletdriver.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];


  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia.prime = {
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ewan = {
    uid = 1000;
    group = "ewan";
    isNormalUser = true;
    description = "ewan";
    extraGroups = [ "docker" "networkmanager" "wheel" "storage" "dialout" "libvirtd"];
    packages = [ ];
  };
  users.groups.ewan.gid = 1000;

  home-manager = {
   extraSpecialArgs = { inherit inputs; };
   users = {
     ewan.imports = [ ./home.nix ];
   };
  };

  security.sudo.wheelNeedsPassword = false;
  security.pam.services = {
    hyprlock = { };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    aerc
    kitty
    btop
    tmux
    fzf
    tree
    ripgrep
    fd
    pulsemixer
    pulseaudio
    pamixer
    firefox
    git
    rofi
    neovim
    awww
    wget
    networkmanagerapplet
    sshfs

    nil
    nixpkgs-fmt
    dunst

    bashmount

    wl-clipboard

    entr

    xdg-utils
    xdg-user-dirs

    appimage-run


    zathura
    zip
    unzip

    xdg-desktop-portal-hyprland

    gcc
    luajitPackages.tree-sitter-cli
    devenv
  ];

 fonts.packages = with pkgs; [
   (nerd-fonts.iosevka-term)
 ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # hardware.pulseaudio.enable = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 4903 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.trusted-users = [ "root" "ewan" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
}

