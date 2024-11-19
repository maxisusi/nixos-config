{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop"; # Define your hostname.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ spectacle ];
}
