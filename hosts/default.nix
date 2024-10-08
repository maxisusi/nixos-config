{ lib, inputs, system, home-manager, user, nixvim, catppuccin, color_scheme, ...
}@attr: {
  # Desktop Environment
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = attr;
    modules = [
      ./desktop
      ../modules/core
      nixvim.nixosModules.nixvim
      catppuccin.nixosModules.catppuccin
      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "hm_backup";
        home-manager.useGlobalPkgs = true;
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

  # Laptop Environment
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = attr;
    modules = [
      ./laptop
      ../modules/core
      nixvim.nixosModules.nixvim
      catppuccin.nixosModules.catppuccin
      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "hm_backup";
        home-manager.useGlobalPkgs = true;
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
        home-manager.useGlobalPkgs = true;
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
