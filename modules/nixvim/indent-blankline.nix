{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [{ plugin = indent-blankline-nvim; }];
  extraConfigLua =
    #lua
    ''
      require("ibl").setup {}
    '';
}
