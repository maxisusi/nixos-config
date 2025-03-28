{ lib, inputs, system, home-manager, user, nixvim, catppuccin, color_scheme
, nixpkgs-unstable, ... }@attr: {
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
      catppuccin.nixosModules.catppuccin
      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "hm_backup";
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs user system color_scheme nixpkgs-unstable;
        }; # Pass flake as variable
        home-manager.users.${user} = {
          imports =
            [ ../modules/home catppuccin.homeManagerModules.catppuccin ];
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
      catppuccin.nixosModules.catppuccin
      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "hm_backup";
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs user system color_scheme;
        }; # Pass flake as variable
        home-manager.users.${user} = {
          imports =
            [ ../modules/home catppuccin.homeManagerModules.catppuccin ];
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
      catppuccin.nixosModules.catppuccin
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
            [ ../modules/home catppuccin.homeManagerModules.catppuccin ];
        };
      }
    ];
  };

}
