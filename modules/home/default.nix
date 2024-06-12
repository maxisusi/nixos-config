{
  imports = [ (import ./tmux.nix) ] ++ [ (import ./layzgit.nix) ]
    ++ [ (import ./starship.nix) ] ++ [ (import ./git.nix) ]
    ++ [ (import ./ssh.nix) ] ++ [ (import ./fish.nix) ]
    ++ [ (import ./core.nix) ] ++ [ (import ./packages.nix) ]
    ++ [ (import ./neovim.nix) ] ++ [ (import ./kitty.nix) ]
    ++ [ (import ./gtk.nix) ] ++ [ (import ./bat.nix) ]
    ++ [ (import ./btop.nix) ];

  catppuccin.flavor = "mocha";

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:none" ];
    }; # Disable caps lock

  };

}
