{ pkgs, inputs, ... }:
let
  # Upstream flake runs `python3 tools/run_tests.py` without declaring python3.
  colibri =
    inputs.colibri.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.python3 ];
      });
  # Not in nixpkgs yet — prebuilt binary from https://www.coderabbit.ai/cli
  coderabbit-cli = pkgs.callPackage ../../packages/coderabbit { };
in
{
  nixpkgs.overlays = [
    (import ../../overlays/freecad.nix)
  ];

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
    claude-code
    herdr
    gemini-cli
    slurp
    hyprshot
    nwg-displays
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
    cura-appimage
    kicad
    orca-slicer
    tailscale
    colibri
    coderabbit-cli
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
