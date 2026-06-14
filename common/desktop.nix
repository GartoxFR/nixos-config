{ inputs, pkgs, ... }:
{
  boot.supportedFilesystems = [ "ntfs" ];

  programs.fuse = {
    userAllowOther = true;
  };

  hardware.graphics = {
    enable = true;
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

  security.sudo.wheelNeedsPassword = false;
  security.pam.services = {
    hyprlock = { };
  };
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
    rofi
    awww
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
    xdg-desktop-portal-hyprland

    gcc
    luajitPackages.tree-sitter-cli
    lazygit
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireguard.enable = true;
  networking.firewall.checkReversePath = false;

  # Configure Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.waybar = {
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --time --cmd start-hyprland";
      user = "ewan";
    };
  };
}
