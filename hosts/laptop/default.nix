{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop"; # Define your hostname.

  # Configure keymap in X11

  services.xserver = {
    xkb = {
      layout = "us,ch";
      variant = "altgr-intl,fr";
    };

    #  -- KDE SETTINGS --
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [ spectacle ];

}
