{ config, lib, pkgs, ... }: {

  imports = [ (import ./hardware.nix) ] ++ [ (import ./user.nix) ]
    ++ [ (import ./pipewire.nix) ] ++ [ (import ./system.nix) ]
    ++ [ (import ./xserver.nix) ] ++ [ (import ./security.nix) ]
    ++ [ (import ./bootloader.nix) ] ++ [ (import ./programs.nix) ]
    ++ [ (import ./bash.nix) ] ++ [ (import ./services.nix) ];

  xserver_host = {
    desktop.enable = (lib.mkIf (config.networking.hostName == "desktop") true);
    laptop.enable = (lib.mkIf (config.networking.hostName == "laptop") true);
  };
  catppuccin.enable = true;

  services.udisks2.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
}
