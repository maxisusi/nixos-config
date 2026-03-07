{ pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.unstable.linuxPackages_zen;

  # Disable the boot entry editor for security (prevents kernel parameter tampering).
  boot.loader.systemd-boot.editor = false;
}
