{ inputs, ... }:
{
  # Noctalia — a prebuilt Quickshell-based Wayland shell and bar.
  # https://docs.noctalia.dev/v5
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    # Run as a systemd user service bound to graphical-session.target, which
    # Hyprland's systemd integration starts. No manual exec-once needed.
    systemd.enable = true;

    # Noctalia owns wallpaper, notifications, launcher and lock screen (the
    # Hyprland equivalents have been removed). Lock authenticates against the
    # standard `login` PAM service.
    settings = {
      # Colors derived from the current wallpaper (changed via the settings
      # UI; was the builtin Kanagawa palette, kept as fallback).
      theme = {
        mode = "dark";
        source = "wallpaper";
        builtin = "Kanagawa";
      };

      # Point at the full wallpapers folder so all of them show in the picker.
      wallpaper.directory = "/home/max/.config/flakes/nixos-config/wallpapers";

      # Weather in the bar (widget added to bar.default.center below).
      # Location is resolved from IP; set location.address to pin a city.
      weather = {
        enabled = true;
        unit = "celsius";
      };
      location.auto_locate = true;

      # Full-width, flush bar (no floating gaps, square corners), styled to
      # match the tweaks made in the settings UI.
      bar.default = {
        margin_ends = 0; # no left/right gaps -> spans full width
        margin_edge = 0; # flush against the screen edge
        radius = 0;
        radius_top_left = 0;
        radius_top_right = 0;
        radius_bottom_left = 0;
        radius_bottom_right = 0;

        background_opacity = 0.4;
        thickness = 41;
        padding = 22;
        widget_spacing = 15;

        # Widget layout (builtin defaults minus launcher/wallpaper/tray).
        start = [ "workspaces" ];
        center = [
          "clock"
          "weather"
        ];
        end = [
          "media"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "control-center"
          "session"
        ];
      };

      # Per-widget styling.
      widget = {
        battery.show_label = false;
        network.show_label = false;
        volume.show_label = false;
        tray.scale = 0.9;
        media = {
          art_size = 21.0;
          capsule = true;
          capsule_padding = 15.0;
          hide_when_no_media = true;
        };
      };

      calendar.enabled = true;
      shell.screen_time_enabled = true;

      # Low-battery warning for the MX Master mouse.
      battery.device."/org/freedesktop/UPower/devices/battery_hidpp_battery_0".warning_threshold =
        20;
    };
  };
}
