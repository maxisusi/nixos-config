{ config, lib, ... }:

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
        desktopManager.plasma6.enable = true;
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
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
