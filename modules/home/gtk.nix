{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = [ pkgs.twemoji-color-font pkgs.noto-fonts-emoji ];

  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
  };
  home.pointerCursor = {
    name = "Banana";
    package = pkgs.banana-cursor;
    size = 40;
  };
}
