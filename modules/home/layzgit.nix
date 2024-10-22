{
  programs.lazygit = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      os = {
        openCommand = "code --goto {{filename}}";
        editCommand = "code";
      };
    };
  };
}
