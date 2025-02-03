{ pkgs, ... }:
let
  startupScript = pkgs.writeShellScriptBin "start" ''
    waybar &
  '';
in {
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty";
    "$fileManager" = "nautilus";
    "$menu" = "rofi -show drun";
    "$lock" = "hyprlock";

    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];

    exec-once = "${startupScript}/bin/start";

    general = {
      gaps_in = 8;
      gaps_out = 0;
      border_size = 1;
      layout = "dwindle";
      resize_on_border = true;
      "col.active_border" = "rgb(cba6f7) rgb(94e2d5) 45deg";
      "col.inactive_border" = "0x00000000";
      border_part_of_window = false;
      no_border_on_floating = false;
    };

    decoration = {
      rounding = 8;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "fluent_decel, 0, 0.2, 0.4, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutCubic, 0.33, 1, 0.68, 1"
        "easeinoutsine, 0.37, 0, 0.63, 1"
      ];
      animation = [
        # Windows
        "windowsIn, 1, 3, easeOutCubic, popin 30%" # window open
        "windowsOut, 1, 3, fluent_decel, popin 70%" # window close.
        "windowsMove, 1, 2, easeinoutsine, slide" # everything in between, moving, dragging, resizing.

        # Fade
        "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
        "fadeOut, 1, 2, easeOutCubic" # fade out (close) -> layers and windows
        "fadeSwitch, 0, 1, easeOutCirc" # fade on changing activewindow and its opacity
        "fadeShadow, 1, 10, easeOutCirc" # fade on changing activewindow for shadows
        "fadeDim, 1, 4, fluent_decel" # the easing of the dimming of inactive windows
        "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
        "borderangle, 1, 30, fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
        "workspaces, 1, 4, easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
      ];
    };

    input = {
      kb_layout = "us,ch";
      kb_variant = "altgr-intl,fr";
      kb_options = "grp:caps_toggle";
      touchpad = { natural_scroll = true; };
    };

    windowrulev2 = [
      "stayfocused,class:(rofi)"
      "workspace 1, class:kitty"
      "workspace 2, class:google-chrome"
      "workspace 3, class:Slack"
      "workspace 3, class:discord"
    ];

    bind = [
      "$mod, M, exec, exit"
      "$mod, Q, killactive"

      "$mod, R, exec, $menu"
      "$mod, T, exec, $terminal"
      "$mod, E, exec, $fileManager"
      "$mod, V, togglefloating"
      "$mod, L, exec, $lock"
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

      ", Print, exec, hyprshot -m region active --clipboard-only "
      "$mod, G, exec, google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland"
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

    monitor = [
      "desc:Chimei Innolux Corporation 0x143F, highrr, 0x0, 1"
      "desc:Philips Consumer Electronics Company PHL 346E2C UK02423042086, highrr, 0x-1440,1"
      ", preferred, auto, 1"
    ];

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

      # ", switch:off:Lid Switch,exec,hyprctl keyword monitor desc:Philips Consumer Electronics Company PHL 346E2C UK02423042086,highrr, 0x0, 1"
      # ", switch:on:Lid Switch,exec,hyprctl keyword monitor desc:Chimei Innolux Corporation 0x1440, disable"
    ];
  };

  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
  home.packages = with pkgs; [
    nautilus
    rofi
    rofi-power-menu
    brightnessctl
    pamixer
    hyprpaper
    hyprpicker
    hypridle
    hyprlock
    dunst
    hyprland-qtutils
    hyprutils
    hyprpolkitagent
    hyprshot
  ];

  programs.rofi.enable = true;
  services.dunst.enable = true;

  programs.hyprlock = {
    enable = true;
    settings = {

      background = {
        path = "screenshot";

        blur_passes = 2;
        blur_size = 7;

        brightness = 0.8;
        contrast = 0.8;

        # color = "${base00}99";
      };

      input-field = {
        size = {
          width = 200;
          height = 50;
        };

        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = false;
        # outer_color = "${base01}";
        # inner_color = "${base07}";
        # font_color = "${base00}";
        fade_on_empty = true;
        placeholder_text = "<i>Type Password...</i>";
        hide_input = false;
        position = {
          x = 0;
          y = -20;
        };
        halign = "center";
        valign = "center";
      };

      label = {
        text = "$TIME";
        # color = "${base05}";
        font_size = 50;
        font_family = "Noto Sans";
        position = {
          x = 0;
          y = 80;
        };
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload =
        [ "/home/max/.config/flakes/nixos-config/wallpapers/purplesky.png" ];
      wallpaper =
        [ ",/home/max/.config/flakes/nixos-config/wallpapers/purplesky.png" ];
    };
  };

}
