{ pkgs, ... }: {
  # Gruvbox color scheme for KiCad. Selectable in Preferences > Common > Colors.
  xdg.configFile."kicad/10.0/colors/gruvbox.json".source = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/flintwinters/kicad-9.0-gruvbox-theme/main/gruvbox.json";
    hash = "sha256-Bm9c7DO0MIPsNPGKvUc/1FIj4SZsgAGhVXntjv4/9qw=";
  };
}
