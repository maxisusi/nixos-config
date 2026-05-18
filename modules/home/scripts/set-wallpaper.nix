{ pkgs, wallpaper }:

pkgs.writeShellScriptBin "set-wallpaper" ''
  wallpaper="${wallpaper}"
  for _ in $(seq 1 30); do
    if hyprctl hyprpaper listactive >/dev/null 2>&1; then
      break
    fi
    sleep 0.2
  done
  hyprctl hyprpaper preload "$wallpaper" >/dev/null 2>&1 || true
  for mon in $(hyprctl -j monitors | ${pkgs.jq}/bin/jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$mon,$wallpaper" >/dev/null 2>&1 || true
  done
''
