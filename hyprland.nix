{ inputs, config, pkgs, ... }:

{

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
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --time --cmd Hyprland";
      user = "ewan";
    };
  };

}
