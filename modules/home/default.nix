{ ... }: {
  imports = [ (import ./tmux.nix) ] ++ [ (import ./layzgit.nix) ]
    ++ [ (import ./starship.nix) ] ++ [ (import ./git.nix) ]
    ++ [ (import ./ssh.nix) ] ++ [ (import ./fish.nix) ]
    ++ [ (import ./core.nix) ] ++ [ (import ./packages.nix) ]
    ++ [ (import ./neovim.nix) ] ++ [ (import ./kitty.nix) ]
    ++ [ (import ./gtk.nix) ] ++ [ (import ./bat.nix) ]
    ++ [ (import ./btop.nix) ] ++ [ (import ./hyprland.nix) ]
    ++ [ (import ./waybar.nix) ]
    ++ [ (import ./ghostty.nix) ];
}
