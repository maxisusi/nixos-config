{ pkgs, ... }: {
  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  wayland.windowManager.hyprland = { catppuccin.enable = true; };
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi --show run";

    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];

    # decoration = { rounding = 10; };

    bind = [
      "$mod, M, exec, exit"
      "$mod, C, killactive"

      "$mod, R, exec, $menu"
      "$mod, Q, exec, $terminal"
      "$mod, E, exec, $fileManager"
      "$mod, V, togglefloating"

      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      ", Print, exec, grimblast copy area"
      "$mod, G, exec, google-chrome-stable"
      ", Print, exec, grimblast copy area"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]) 9));

    bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];
  };
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

  home.packages = with pkgs; [ wofi dolphin ];

  programs.wofi = { enable = true; };

}
