{ config, lib, ... }:

let cfg = config.MyConf;
in {

  options.MyConf = {
    desktop.enable = lib.mkEnableOption "desktop configuration for MyConf";
    laptop.enable = lib.mkEnableOption "desktop configuration for MyConf";
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
          desktopManager.plasma5.enable = true;
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
