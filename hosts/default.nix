{ lib, inputs, system, home-manager, user, nixvim, ... }@attr: {
  # Desktop Environment
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = attr;
    modules = [
      ./desktop
      ./configuration.nix
      nixvim.nixosModules.nixvim

      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "backup";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs user system;
        }; # Pass flake as variable
        home-manager.users.${user} = { imports = [ ./home.nix ]; };
      }
    ];
  };

  # Laptop Environment
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = attr;
    modules = [
      ./laptop
      ./configuration.nix
      nixvim.nixosModules.nixvim

      home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "backup";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs user system;
        }; # Pass flake as variable
        home-manager.users.${user} = { imports = [ ./home.nix ]; };
      }
    ];
  };

}
