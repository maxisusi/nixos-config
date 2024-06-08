{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    excludePackages = with pkgs.libsForQt5; [ spectacle ];
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
