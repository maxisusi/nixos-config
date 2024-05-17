
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us,ch"; 
      variant = "altgr-intl,fr";
    };
  };

}
