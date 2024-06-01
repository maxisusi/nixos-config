{ pkgs ? import <nixpkgs> { } }:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents
    (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nodePackages_latest.npm # npm
    nodejs
    yarn
    tmuxifier
    zsh
    gnumake
    rsync
    nodenv
    gdk
    (callPackage ../../packages/sloth { })
  ];

  shellHook = ''
    tmuxifier load-session ./tipee-run.sh # Load tipee session
  '';
}
