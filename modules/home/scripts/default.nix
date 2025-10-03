{ pkgs }:

{
  startup = import ./startup.nix { inherit pkgs; };
  screenshot = import ./screenshot.nix { inherit pkgs; };
}