{ pkgs, inputs, system, color_scheme, ... }:
let
  neovimConfig = import ../nixvim;
  nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    extraSpecialArgs = { inherit color_scheme; };
    module = neovimConfig;
  };
in { home.packages = [ nvim ]; }
