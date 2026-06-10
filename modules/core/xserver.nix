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
          wayland.enable = true;
        };
      };
      # Unlock the GNOME Keyring (Secret Service) with the login password at
      # SDDM login. Without this the keyring stays locked under Hyprland, so
      # apps like 1Password can't persist secrets (e.g. the 2FA token) and fail
      # with "unable to save your two-factor token".
      security.pam.services.sddm.enableGnomeKeyring = true;
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
