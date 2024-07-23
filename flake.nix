{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hyprland = {
       url = "/home/ewan/dev/Hyprland/";
       inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle= {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar.url = "github:Alexays/Waybar";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sway-opacity-manager = {
      url = "github:GartoxFR/sway_opacity_manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@ inputs: {

    nixosConfigurations.sway = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        ./configuration.nix 
        ./sway.nix
        inputs.home-manager.nixosModules.default 
      ];
    };
    nixosConfigurations.hyprland = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        ./configuration.nix 
        ./hyprland.nix
        inputs.home-manager.nixosModules.default 
      ];
    };

    nixosConfigurations.gnome = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        ./configuration.nix 
        ./gnome.nix
        inputs.home-manager.nixosModules.default 
      ];
    };

  };
}
