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
  stylix = {
    enable = true;
    # image = ../../wallpapers/cliff.png;
    base16Scheme = ../../alabaster.yaml;
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
    targets = { nixvim.enable = false; };
  };

  services.udisks2.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  programs.nixvim = {
    enable = true;
    imports = [ ../nixvim ];
  };
}
