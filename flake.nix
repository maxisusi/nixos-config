{
  description = "Max Balej - Linux configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, nixvim, catppuccin, hyprland, ... }@inputs:
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      user = "max";
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      nixosConfigurations = (import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs user system home-manager nixvim catppuccin hyprland;
      });
    };
}
