{
  imports = [ (import ./tmux.nix) ] ++ [ (import ./layzgit.nix) ]
    ++ [ (import ./starship.nix) ] ++ [ (import ./git.nix) ]
    ++ [ (import ./ssh.nix) ] ++ [ (import ./fish.nix) ]
    ++ [ (import ./core.nix) ] ++ [ (import ./packages.nix) ]
    ++ [ (import ./neovim.nix) ] ++ [ (import ./kitty.nix) ]
    ++ [ (import ./gtk.nix) ] ++ [ (import ./bat.nix) ]
    ++ [ (import ./btop.nix) ] ++ [ (import ./wofi.nix) ]
    ++ [ (import ./audacious/audacious.nix) ] ++ [ (import ./hyprland) ]
    ++ [ (import ./waybar) ] ++ [ (import ./scripts/scripts.nix) ]
    ++ [ (import ./swaylock.nix) ];

  catppuccin.flavor = "mocha";
}
