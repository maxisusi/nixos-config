{ lib, ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration = { enableFishIntegration = true; };
    settings = {
      adjust_line_height = 2;
      initial_window_width = 920;
      initial_window_height = 1080;
      hide_window_decorations = "yes";
      font_family =
        "JetBrainsMono Nerd Font,JetBrainsMono NF:style=Bold Italic";
      font_size = 14;
    };
  };
}
