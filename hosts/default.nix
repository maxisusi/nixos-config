{ lib, inputs, system, home-manager, user, nixvim, catppuccin, hyprland, ...
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
        home-manager.backupFileExtension = "backup";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs user system;
        }; # Pass flake as variable
        home-manager.users.${user} = {
          imports = [
            ../modules/home
            catppuccin.homeManagerModules.catppuccin
            # hyprland.homeManagerModules.default
          ];
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
        home-manager.backupFileExtension = "backup";
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
