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
    image = ../../wallpapers/neosaka.jpg;
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };
  };

  services.udisks2.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
}
