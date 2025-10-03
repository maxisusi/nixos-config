{ pkgs }:

pkgs.writeShellScriptBin "start" ''
  waybar &
  systemctl --user start hyprpolkitagent
''