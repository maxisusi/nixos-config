{ pkgs, inputs, system, ... }:
let
  neovimConfig = import ../nixvim;
  nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    module = neovimConfig;
  };
in
{ home.packages = [ nvim ]; }
