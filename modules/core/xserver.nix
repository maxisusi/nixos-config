{ config, lib, pkgs, ... }:

let cfg = config.xserver_host;
in {
  options.xserver_host = {
    desktop.enable =
      lib.mkEnableOption "desktop configuration for xserver_host";
    laptop.enable = lib.mkEnableOption "desktop configuration for xserver_host";
  };

  config = lib.mkMerge [
    {
      services = {
        displayManager.sddm = {
          enable = true;
          # Run SDDM (the greeter) under X11, not Wayland. Nvidia + Wayland on
          # the login screen causes the boot to hang at the SDDM greeter. The
          # actual desktop session (Hyprland) is still Wayland.
          wayland.enable = false;
        };
      };
    }
    (lib.mkIf cfg.desktop.enable {
      services = {
        xserver = {
          enable = true;
          xkb = {
            layout = "us";
            variant = "altgr-intl";
          };
        };
      };
    })
    (lib.mkIf cfg.laptop.enable {
      services = {
        xserver = {
          enable = true;
          xkb = {
            layout = "us,ch";
            variant = "altgr-intl,fr";
            options = "ctrl:nocaps";
          };
        };
      };
    })
  ];
}
