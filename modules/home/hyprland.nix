{ pkgs, lib, ... }:
let
  scripts = import ./scripts { inherit pkgs; };
  startupScript = scripts.startup;
  screenshotScript = scripts.screenshot;
  nhSwitchScript = scripts.nhSwitch;
  webappLauncherScript = scripts.webappLauncher;
in {
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "ghostty";
    "$fileManager" = "nautilus";
    "$menu" = "wofi";
    "$lock" = "hyprlock";

    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "GTK_SCALE,1.25"
    ];

    exec-once = "${startupScript}/bin/start";

    general = {
      gaps_in = 8;
      gaps_out = 8;
      border_size = 1;
      layout = "dwindle";
      resize_on_border = true;
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
        "border, 0, 2.7, easeOutCirc" # for animating the border's color switch speed
        "borderangle, 1, 30, fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
        "workspaces, 0, 4, easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
      ];
    };

    input = {
      kb_layout = "us,ch";
      kb_variant = "altgr-intl,fr";
      kb_options = "grp:caps_toggle";
      touchpad = {
        natural_scroll = true;
        disable_while_typing = false;
      };
      repeat_delay = 200;
      repeat_rate = 30;
    };

    windowrulev2 = [
      "stayfocused,class:(wofi)"
      "workspace 1, monitor 1, class:ghostty"
      "workspace 2, monitor 1, class:google-chrome"
      "workspace 3, monitor 0, class:Slack"
      "workspace 3, monitor 0, class:discord"
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

      ", Print, exec, ${screenshotScript}/bin/screenshot"
      "$mod SHIFT, Print, exec, hyprpicker -a"
      "$mod, G, exec, google-chrome-stable"
      "$mod, C, exec, kitty -d ~/.config/flakes/nixos-config nvim flake.nix"
      "$mod, p, exec, kitty btop"
      "$mod, U, exec, ${nhSwitchScript}/bin/nh-switch"

      # Apps
      "$mod SHIFT, S, exec, slack"
      "$mod SHIFT, D, exec, discord"
      "$mod SHIFT, O, exec, obsidian"
      "$mod SHIFT, M, exec, ${webappLauncherScript}/bin/webapp-launcher https://mail.proton.me/"
      "$mod SHIFT, R, exec, ${webappLauncherScript}/bin/webapp-launcher https://docs.rs/"

      # AI's
      "$mod SHIFT, P, exec, ${webappLauncherScript}/bin/webapp-launcher https://www.perplexity.ai/"
      "$mod SHIFT, G, exec, ${webappLauncherScript}/bin/webapp-launcher https://grok.com/"
      "$mod SHIFT, C, exec, ${webappLauncherScript}/bin/webapp-launcher https://chatgpt.com/"
      "$mod SHIFT, T, exec, ${webappLauncherScript}/bin/webapp-launcher https://app.todoist.com/"

    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]) 9));

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"

      # "$mod ALT, mouse_down, exec, hyprctl keyword cursor:zoom_factor `$(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor * 1.25}')`"
      # "$mod ALT, mouse_up, exec, hyprctl keyword cursor:zoom_factor `$(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor / 1.25}')`"
    ];

    monitor = [
      "desc:Chimei Innolux Corporation 0x143F, highrr, 0x0, 1"
      "DP-3, preferred, auto,1"
      "DP-1, 3440x1440@74.98Hz, 0x-1440,1"
      # ", preferred, auto, 1"
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
    wofi
    # rofi
    # rofi-power-menu
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
    wf-recorder
    slurp
    hyprsunset
    webappLauncherScript
  ];

  # programs.rofi.enable = true;
  services.dunst = { enable = true; };

  programs.hyprlock = { enable = true; };
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
        [ "/home/max/.config/flakes/nixos-config/wallpapers/beach.png" ];
      wallpaper =
        [ ",/home/max/.config/flakes/nixos-config/wallpapers/beach.png" ];
    };
  };

}
