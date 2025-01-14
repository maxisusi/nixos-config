{ pkgs, ... }:
let
  startupScript = pkgs.writeShellScriptBin "start" ''
    waybar 
  '';
in {
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "rofi -show drun";

    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];

    exec-once = "${startupScript}/bin/start";

    monitor = [
      "desc:Chimei Innolux Corporation 0x143F, highrr, 0x0, 1"
      "desc:Philips Consumer Electronics Company PHL 346E2C UK02423042086, highrr, 0x-1440,1"
      ", preferred, auto, 1"
    ];

    general = {
      gaps_in = 0;
      gaps_out = 10;
      border_size = 1;
      layout = "dwindle";
      resize_on_border = true;
      "col.active_border" = "rgb(cba6f7) rgb(94e2d5) 45deg";
      "col.inactive_border" = "0x00000000";
      border_part_of_window = false;
      no_border_on_floating = false;
    };

    decoration = {
      rounding = 3;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
      };

    };

    input = {
      kb_layout = "us,ch";
      kb_variant = "altgr-intl,fr";
      kb_options = "grp:caps_toggle";
      touchpad = { natural_scroll = true; };
    };

    windowrulev2 = [ "stayfocused,class:(rofi)" ];

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
      "$mod, P, pseudo"

      "$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"
      "$mod CTRL, left, resizeactive, -80 0"
      "$mod CTRL, right, resizeactive, 80 0"
      "$mod CTRL, up, resizeactive, 0 -80"
      "$mod CTRL, down, resizeactive, 0 80"
      "$mod ALT, left, moveactive,  -80 0"
      "$mod ALT, right, moveactive, 80 0"
      "$mod ALT, up, moveactive, 0 -80"
      "$mod ALT, down, moveactive, 0 80"

      ", Print, exec, grimblast copy area"
      "$mod, G, exec, google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland"
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
      ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      "$mod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
      "$mod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
      # Volume
      ",XF86AudioRaiseVolume, exec, pamixer -i 5"
      ",XF86AudioLowerVolume, exec, pamixer -d 5"
      "$mod, XF86AudioRaiseVolume, exec, pamixer -i 10"
      "$mod, XF86AudioLowerVolume, exec, pamixer -d 10"
      # Mute Audio
      ",XF86AudioMute, exec, pamixer -t"
      # Mute micro
      ",XF86AudioMicMute, exec, pamixer --default-source -t"
    ];
  };

  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
  home.packages = with pkgs; [ dolphin rofi brightnessctl pamixer ];

}
