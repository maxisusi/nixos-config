{ lib, ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration = { enableFishIntegration = true; };
    settings = {
      adjust_line_height = 2;
      initial_window_width = 920;
      initial_window_height = 1080;
      hide_window_decorations = "yes";
      background_opacity = lib.mkForce "0.9";
    };
  };
}
