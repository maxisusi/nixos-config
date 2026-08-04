{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "laptop_hp";

  # Not covered by xserver_host (desktop/laptop only); SDDM needs X11 enabled.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "ch";
      variant = "fr";
    };
  };

}
