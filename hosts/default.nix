{ lib, inputs, system, home-manager, user, nixvim, stylix, nixpkgs-unstable, ... }@attr: {
  # Desktop Environment
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = attr;
    modules = [
      {
        nixpkgs.overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      }
      ./desktop
      ../modules/core
      nixvim.nixosModules.nixvim
      stylix.nixosModules.stylix
      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "hm_backup";
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs user system nixpkgs-unstable;
        }; # Pass flake as variable
        home-manager.users.${user} = {
          imports = [ ../modules/home ];
        };
      }
    ];
  };

  # Laptop Environment
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = attr;
    modules = [
      {
        nixpkgs.overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      }
      ./laptop
      ../modules/core
      nixvim.nixosModules.nixvim
      stylix.nixosModules.stylix
      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "hm_backup";
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs user system;
        }; # Pass flake as variable
        home-manager.users.${user} = {
          imports = [ ../modules/home ];
        };
      }
    ];
  };

  laptop_hp = lib.nixosSystem {
    inherit system;
    specialArgs = attr;
    modules = [
      ./laptop_hp
      ../modules/core
      nixvim.nixosModules.nixvim
      stylix.nixosModules.stylix
      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "hm_backup";
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs user system;
        }; # Pass flake as variable
        home-manager.users.${user} = {
          imports =
            [ ../modules/home stylix.homeManagerModules.stylix ];
        };
      }
    ];
  };

}
