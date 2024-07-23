{ inputs, config, pkgs, ... }:

{

  # Configure Hyprland
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export LIBVA_DRIVER_NAME=nvidia
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export GBM_BACKEND=nvidia-drm;
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1;
      export GDK_BACKEND=wayland
    '';
    extraPackages = [
      inputs.sway-opacity-manager.packages.${pkgs.system}.default
    ];
    extraOptions = ["--unsupported-gpu"];
  };

  programs.waybar = {
    enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
  
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "sway";
        user = "ewan";
      };
    };
  };
  
}
