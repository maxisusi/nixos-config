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
  };

}
