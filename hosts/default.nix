{ lib, inputs, system, home-manager, user, nixvim, stylix, ... }@attr:
let
  # Every host gets the same stack; only the host dir differs.
  common = [
    ../modules/core
    nixvim.nixosModules.nixvim
    stylix.nixosModules.stylix
    home-manager.nixosModules.home-manager
    {
      home-manager.backupFileExtension = "hm_backup";
      home-manager.useGlobalPkgs = false;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs user system; };
      home-manager.users.${user} = { imports = [ ../modules/home ]; };
    }
  ];
  host = dir:
    lib.nixosSystem {
      inherit system;
      specialArgs = attr;
      modules = [ dir ] ++ common;
    };
in {
  desktop = host ./desktop;
  laptop = host ./laptop;
  laptop_hp = host ./laptop_hp;
}
