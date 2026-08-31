{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "laptop";

  # Build/deploy aarch64 closures (speedsoft Pi 5 SD image) via QEMU.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Compressed swap in RAM, no disk involvement. Gives the kernel somewhere to
  # put cold pages instead of thrashing the page cache under memory pressure,
  # and un-degrades systemd-oomd, which needs swap to monitor anything.
  # Laptop only: 30G of RAM and heavy docker/node/Electron load.
  zramSwap.enable = true;

  # Turns on the Ozone Wayland backend 
  environment = {
    variables = { NIXOS_OZONE_WL = 1; };
    systemPackages = with pkgs; [ google-chrome ];
  };

}
