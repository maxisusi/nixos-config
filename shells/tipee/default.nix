{ pkgs ? import <nixpkgs> { } }:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents
    (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    yarn
    tmuxifier
    zsh
    gnumake
    rsync
    nodenv
    gdk
    (callPackage ../../packages/sloth { })
    nodejs
  ];

  shellHook = ''
    npm config set prefix $TMPDIR # Store the global dir in a temporary folder to install global npm packages
    npm i -g @styled/typescript-styled-plugin typescript-styled-plugin
    tmuxifier load-session ./tipee-run.sh # Load tipee session
  '';
}
