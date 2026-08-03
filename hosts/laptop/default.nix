{ pkgs, lib, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  networking.hostName = "laptop"; # Define your hostname.

  # Kernel 7.1.x breaks USB-C DisplayPort alt mode on Lunar Lake (external
  # monitor not detected). Pin LTS until fixed, then drop this override.
  boot.kernelPackages = lib.mkForce pkgs.unstable.linuxPackages;

  # Build/deploy aarch64 closures (speedsoft Pi 5 SD image) via QEMU.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Turns on the Ozone Wayland backend 
  environment = {
    variables = { NIXOS_OZONE_WL = 1; };
    systemPackages = with pkgs; [ google-chrome ];
  };

}
