{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = [ 
    pkgs.twemoji-color-font 
    pkgs.noto-fonts-color-emoji 
    pkgs.dejavu_fonts
    pkgs.liberation_ttf
    pkgs.noto-fonts
  ];

  gtk = {
    enable = true;
  };
  home.pointerCursor = {
    name = "Banana";
    package = pkgs.banana-cursor;
    size = 40;
  };
}
