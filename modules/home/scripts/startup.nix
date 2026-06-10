{ pkgs }:

pkgs.writeShellScriptBin "start" ''
  # Noctalia (bar, wallpaper, notifications, launcher, lock) launches via its
  # systemd user service (programs.noctalia.systemd).
  systemctl --user start hyprpolkitagent
''
