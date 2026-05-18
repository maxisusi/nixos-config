{ pkgs, setWallpaper }:

pkgs.writeShellScriptBin "start" ''
  waybar &
  systemctl --user start hyprpolkitagent
  ${setWallpaper}/bin/set-wallpaper &
''
