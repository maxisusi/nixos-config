{ pkgs, ... }:
let
  # Override claude-code to the latest release until nixpkgs catches up.
  # Update version + sha256 from https://downloads.claude.ai/claude-code-releases/<version>/manifest.json (linux-x64 checksum).
  claude-code-latest = pkgs.claude-code.overrideAttrs (old: rec {
    version = "2.1.170";
    src = pkgs.fetchurl {
      url = "https://downloads.claude.ai/claude-code-releases/${version}/linux-x64/claude";
      sha256 = "849e007277a0442ab27570d3e3d6d43787507946590e8dd1947e5a39b7081f9e";
    };
  });
in
{

  home.packages = with pkgs; [
    oh-my-fish
    slack
    vscode
    ripgrep
    jq
    tokei
    python3
    zoxide
    rustfmt
    cargo
    discord
    vlc
    libreoffice
    vscode-extensions.vadimcn.vscode-lldb.adapter
    direnv
    obsidian
    atuin
    zsh
    go
    wl-clipboard
    yazi
    fd
    fzf
    poppler
    imagemagick
    p7zip
    ffmpeg
    tmuxifier
    tree
    lsof
    gnome-calculator
    gdb
    wget
    tomato-c
    claude-code-latest
    gemini-cli
    slurp
    hyprshot
    satty
    kooha
    wiremix
    bluetui
    jocalsend
    yaak
    gnumake
    nodejs
    yarn
    just
    opencode
    tree-sitter
    bitwarden-desktop
    gh
    brave
    android-studio
    jetbrains.datagrip
    pay-respects
    freecad
  ];

  services.udiskie = {
    enable = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
      };
    };
  };

}
