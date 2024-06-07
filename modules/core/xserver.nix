{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    excludePackages = with pkgs.libsForQt5; [ spectacle ];
  };
}
