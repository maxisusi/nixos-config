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
      # Default color scheme: Kanagawa (a builtin theme compiled into noctalia).
      theme = {
        mode = "dark";
        source = "builtin";
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

      # Full-width, flush bar (no floating gaps, square corners).
      bar.default = {
        margin_ends = 0; # no left/right gaps -> spans full width
        margin_edge = 0; # flush against the screen edge
        radius = 0;
        radius_top_left = 0;
        radius_top_right = 0;
        radius_bottom_left = 0;
        radius_bottom_right = 0;

        # Overrides the builtin default of just ["clock"]; start/end keep
        # their compiled-in defaults.
        center = [
          "clock"
          "weather"
        ];
      };
    };
  };
}
