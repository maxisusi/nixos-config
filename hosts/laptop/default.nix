{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us,ch";
      variant = "altgr-intl,fr";
    };
  };

}
