{ pkgs, inputs, ... }:
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
  # Pin discord to the latest release (nixpkgs lags and it nags to update).
  # Pull orca-slicer from nixpkgs master (2.3.2 has a broken 3D view, see overlay).
  nixpkgs.overlays = [
    (import ../../overlays/discord.nix)
    (import ../../overlays/orca-slicer.nix)
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
