{
  lib,
  pkgs,
  ...
}:
let
  wallpaperPath = "/home/max/.config/flakes/nixos-config/wallpapers/neosaka.jpg";
  scripts = import ./scripts {
    inherit pkgs;
    wallpaper = wallpaperPath;
  };
  startupScript = scripts.startup;
  screenshotScript = scripts.screenshot;
  nhSwitchScript = scripts.nhSwitch;
  webappLauncherScript = scripts.webappLauncher;

  # Lua config helpers (Hyprland 0.55+ deprecated hyprlang for Lua).
  # Variables like the old $mod are plain Nix bindings interpolated below.
  lua = lib.generators.mkLuaInline;
  mod = "SUPER";
  terminal = "ghostty";
  fileManager = "nautilus";
  menu = "noctalia msg panel-toggle launcher";
  lock = "noctalia msg session lock";
  browser = "firefox";
  exec = cmd: "hl.dsp.exec_cmd(${builtins.toJSON cmd})";
  mkBind = keys: action: { _args = [ keys (lua action) ]; };
  mkBindFlags = keys: action: flags: { _args = [ keys (lua action) flags ]; };
in
{
  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  wayland.windowManager.hyprland.configType = "lua";

  wayland.windowManager.hyprland.settings = {
    env = map (e: { _args = e; }) [
      [ "LIBVA_DRIVER_NAME" "nvidia" ]
      [ "XDG_SESSION_TYPE" "wayland" ]
      [ "GBM_BACKEND" "nvidia-drm" ]
      [ "__GLX_VENDOR_LIBRARY_NAME" "nvidia" ]
      [ "GTK_SCALE" "1.25" ]
    ];

    # exec-once equivalent.
    on = {
      _args = [
        "hyprland.start"
        (lua "function() hl.exec_cmd(\"${startupScript}/bin/start\") end")
      ];
    };

    # Sections merge with the colors stylix injects under settings.config.
    config = {
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          vibrancy = 0.1696;
        };
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
    };

    curve = map (c: { _args = c; }) [
      [
        "fluent_decel"
        {
          type = "bezier";
          points = [ [ 0 0.2 ] [ 0.4 1 ] ];
        }
      ]
      [
        "easeOutCirc"
        {
          type = "bezier";
          points = [ [ 0 0.55 ] [ 0.45 1 ] ];
        }
      ]
      [
        "easeOutCubic"
        {
          type = "bezier";
          points = [ [ 0.33 1 ] [ 0.68 1 ] ];
        }
      ]
      [
        "easeinoutsine"
        {
          type = "bezier";
          points = [ [ 0.37 0 ] [ 0.63 1 ] ];
        }
      ]
    ];

    animation = [
      { leaf = "global"; enabled = true; speed = 4; bezier = "easeOutCubic"; }

      # Windows
      { leaf = "windowsIn"; enabled = true; speed = 3; bezier = "easeOutCubic"; style = "popin 30%"; } # window open
      { leaf = "windowsOut"; enabled = true; speed = 3; bezier = "fluent_decel"; style = "popin 70%"; } # window close
      { leaf = "windowsMove"; enabled = true; speed = 2; bezier = "easeinoutsine"; style = "slide"; } # moving, dragging, resizing

      # Fade
      { leaf = "fadeIn"; enabled = true; speed = 3; bezier = "easeOutCubic"; } # fade in (open) -> layers and windows
      { leaf = "fadeOut"; enabled = true; speed = 2; bezier = "easeOutCubic"; } # fade out (close) -> layers and windows
      { leaf = "fadeSwitch"; enabled = false; } # fade on changing activewindow and its opacity
      { leaf = "fadeShadow"; enabled = true; speed = 10; bezier = "easeOutCirc"; } # fade on changing activewindow for shadows
      { leaf = "fadeDim"; enabled = true; speed = 4; bezier = "fluent_decel"; } # the easing of the dimming of inactive windows
      { leaf = "border"; enabled = false; } # border color switch speed
      { leaf = "borderangle"; enabled = true; speed = 30; bezier = "fluent_decel"; style = "once"; } # border gradient angle
      { leaf = "workspaces"; enabled = false; } # styles: slide, slidevert, fade, slidefade, slidefadevert
    ];

    window_rule = [
      { match.class = "ghostty"; workspace = "1"; monitor = "1"; }
      { match.class = "firefox"; workspace = "2"; monitor = "1"; }
      { match.class = "Slack"; workspace = "3"; monitor = "0"; }
      { match.class = "discord"; workspace = "3"; monitor = "0"; }
    ];

    bind = [
      (mkBind "${mod} + M" (exec "exit")) # was `exec, exit` in hyprlang: a shell no-op, kept as-is
      (mkBind "${mod} + Q" "hl.dsp.window.close()")

      (mkBind "${mod} + R" (exec menu))
      (mkBind "${mod} + T" (exec terminal))
      (mkBind "${mod} + E" (exec fileManager))
      (mkBind "${mod} + V" "hl.dsp.window.float()")
      (mkBind "${mod} + F" "hl.dsp.window.fullscreen()")
      (mkBind "${mod} + L" (exec lock))
      (mkBind "${mod} + left" ''hl.dsp.focus({ direction = "l" })'')
      (mkBind "${mod} + right" ''hl.dsp.focus({ direction = "r" })'')
      (mkBind "${mod} + up" ''hl.dsp.focus({ direction = "u" })'')
      (mkBind "${mod} + down" ''hl.dsp.focus({ direction = "d" })'')

      (mkBind "${mod} + SHIFT + left" ''hl.dsp.window.move({ direction = "l" })'')
      (mkBind "${mod} + SHIFT + right" ''hl.dsp.window.move({ direction = "r" })'')
      (mkBind "${mod} + SHIFT + up" ''hl.dsp.window.move({ direction = "u" })'')
      (mkBind "${mod} + SHIFT + down" ''hl.dsp.window.move({ direction = "d" })'')
      (mkBind "${mod} + CTRL + left" "hl.dsp.window.resize({ x = -80, y = 0, relative = true })")
      (mkBind "${mod} + CTRL + right" "hl.dsp.window.resize({ x = 80, y = 0, relative = true })")
      (mkBind "${mod} + CTRL + up" "hl.dsp.window.resize({ x = 0, y = -80, relative = true })")
      (mkBind "${mod} + CTRL + down" "hl.dsp.window.resize({ x = 0, y = 80, relative = true })")
      (mkBind "${mod} + ALT + left" "hl.dsp.window.move({ x = -80, y = 0, relative = true })")
      (mkBind "${mod} + ALT + right" "hl.dsp.window.move({ x = 80, y = 0, relative = true })")
      (mkBind "${mod} + ALT + up" "hl.dsp.window.move({ x = 0, y = -80, relative = true })")
      (mkBind "${mod} + ALT + down" "hl.dsp.window.move({ x = 0, y = 80, relative = true })")

      (mkBind "Print" (exec "${screenshotScript}/bin/screenshot"))
      (mkBind "${mod} + SHIFT + Print" (exec "hyprpicker -a"))
      (mkBind "${mod} + G" (exec browser))
      (mkBind "${mod} + C" (exec "ghostty -e bash -c 'cd ~/.config/flakes/nixos-config && nvim flake.nix'"))
      (mkBind "${mod} + p" (exec "ghostty -e btop"))
      (mkBind "${mod} + U" (exec "${nhSwitchScript}/bin/nh-switch"))

      # Apps
      (mkBind "${mod} + SHIFT + S" (exec "slack"))
      (mkBind "${mod} + SHIFT + D" (exec "discord"))
      (mkBind "${mod} + SHIFT + O" (exec "obsidian"))
      (mkBind "${mod} + SHIFT + M" (exec "${webappLauncherScript}/bin/webapp-launcher https://mail.proton.me/"))
      (mkBind "${mod} + SHIFT + R" (exec "${webappLauncherScript}/bin/webapp-launcher https://docs.rs/"))

      # AI's
      (mkBind "${mod} + SHIFT + P" (exec "${webappLauncherScript}/bin/webapp-launcher https://www.perplexity.ai/"))
      (mkBind "${mod} + SHIFT + G" (exec "${webappLauncherScript}/bin/webapp-launcher https://grok.com/"))
      (mkBind "${mod} + SHIFT + C" (exec "${webappLauncherScript}/bin/webapp-launcher https://chatgpt.com/"))
      (mkBind "${mod} + SHIFT + T" (exec "${webappLauncherScript}/bin/webapp-launcher https://app.todoist.com/"))
    ]
    ++ (
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = toString (i + 1);
          in
          [
            (mkBind "${mod} + code:1${toString i}" "hl.dsp.focus({ workspace = ${ws} })")
            (mkBind "${mod} + SHIFT + code:1${toString i}" "hl.dsp.window.move({ workspace = ${ws}, follow = true })")
          ]
        ) 9
      )
    )
    ++ [
      # Mouse binds (old bindm)
      (mkBindFlags "${mod} + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
      (mkBindFlags "${mod} + mouse:273" "hl.dsp.window.resize()" { mouse = true; })

      # Repeating binds (old bindel)
      (mkBindFlags "XF86MonBrightnessUp" (exec "brightnessctl set 5%+") { repeating = true; })
      (mkBindFlags "XF86MonBrightnessDown" (exec "brightnessctl set 5%-") { repeating = true; })
      (mkBindFlags "${mod} + XF86MonBrightnessUp" (exec "brightnessctl set 100%+") { repeating = true; })
      (mkBindFlags "${mod} + XF86MonBrightnessDown" (exec "brightnessctl set 100%-") { repeating = true; })
      # Volume
      (mkBindFlags "XF86AudioRaiseVolume" (exec "pamixer -i 5") { repeating = true; })
      (mkBindFlags "XF86AudioLowerVolume" (exec "pamixer -d 5") { repeating = true; })
      (mkBindFlags "${mod} + XF86AudioRaiseVolume" (exec "pamixer -i 10") { repeating = true; })
      (mkBindFlags "${mod} + XF86AudioLowerVolume" (exec "pamixer -d 10") { repeating = true; })
      # Mute Audio
      (mkBindFlags "XF86AudioMute" (exec "pamixer -t") { repeating = true; })
      # Mute micro
      (mkBindFlags "XF86AudioMicMute" (exec "pamixer --default-source -t") { repeating = true; })
    ];

    # No "monitor" rules here on purpose: nwg-displays owns the layout and
    # rewrites ~/.config/hypr/monitors.lua on Save, sourced by extraConfig
    # below. Unlisted outputs fall back to Hyprland's preferred/auto/1.
  };

  # Source the nwg-displays output. Guarded on existence so a machine that
  # has never run nwg-displays still starts; a syntax error in a generated
  # file is left to fail loudly rather than being swallowed by pcall.
  wayland.windowManager.hyprland.extraConfig = ''
    local monitors = "/home/max/.config/hypr/monitors.lua"
    local handle = io.open(monitors)
    if handle then
      handle:close()
      dofile(monitors)
    end
  '';

  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
  home.packages = with pkgs; [
    nautilus
    # rofi
    # rofi-power-menu
    brightnessctl
    pamixer
    hyprpicker
    hypridle
    hyprland-qtutils
    hyprutils
    hyprpolkitagent
    hyprshot
    wf-recorder
    slurp
    hyprsunset
    webappLauncherScript
  ];

  # Wallpaper, notifications, app launcher and lock screen are now handled by
  # Noctalia (see ./noctalia.nix), replacing hyprpaper, dunst, wofi and hyprlock.

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "noctalia msg session lock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "noctalia msg session lock";
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

}
