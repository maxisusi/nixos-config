{
  description = "Max Balej - Linux configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =  { self, nixpkgs, home-manager, nixvim, ... } @inputs: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      user = "max";
      in {
        nixosConfigurations = (
          import ./hosts {
            inherit (nixpkgs) lib;
            inherit inputs user system home-manager nixvim;
          }
        );
      };
}
