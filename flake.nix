{
  description = "Max Balej - Linux configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    hyprland.url = "github:hyprwm/Hyprland";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, catppuccin, nixpkgs-unstable
    , ... }@inputs:
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      color_scheme = "frappe";
      lib = nixpkgs.lib;
      user = "max";
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      nixosConfigurations = (import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs user system home-manager nixvim catppuccin color_scheme
          nixpkgs-unstable;
      });
    };
}
