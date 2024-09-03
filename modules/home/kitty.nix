{
  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    font = {
      name = "JetBrainsMono NF SemiBold";
      size = 10.0;
    };
    shellIntegration = { enableFishIntegration = true; };
    settings = {
      adjust_line_height = 2;
      initial_window_width = 920;
      initial_window_height = 1080;
      hide_window_decorations = "yes";
    };
  };
}
