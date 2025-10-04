{ pkgs }:

{
  startup = import ./startup.nix { inherit pkgs; };
  screenshot = import ./screenshot.nix { inherit pkgs; };
  nhSwitch = import ./nh-switch.nix { inherit pkgs; };
  webappLauncher = import ./webapp-launcher.nix { inherit pkgs; };
}