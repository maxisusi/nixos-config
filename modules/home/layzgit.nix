{
  programs.lazygit = {
    enable = true;
    settings = {
      os = {
        openCommand = "code --goto {{filename}}";
        editCommand = "code";
      };
      git = { overrideGpg = true; };
    };
  };
}
