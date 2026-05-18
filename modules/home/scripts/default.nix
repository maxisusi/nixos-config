{ pkgs, wallpaper }:

let
  setWallpaper = import ./set-wallpaper.nix { inherit pkgs wallpaper; };
in
{
  inherit setWallpaper;
  startup = import ./startup.nix { inherit pkgs setWallpaper; };
  screenshot = import ./screenshot.nix { inherit pkgs; };
  nhSwitch = import ./nh-switch.nix { inherit pkgs; };
  webappLauncher = import ./webapp-launcher.nix { inherit pkgs; };
}