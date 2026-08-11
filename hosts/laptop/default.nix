{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "laptop";

  # Build/deploy aarch64 closures (speedsoft Pi 5 SD image) via QEMU.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Turns on the Ozone Wayland backend 
  environment = {
    variables = { NIXOS_OZONE_WL = 1; };
    systemPackages = with pkgs; [ google-chrome ];
  };

}
