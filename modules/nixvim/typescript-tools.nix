{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [{ plugin = typescript-tools-nvim; }];
  extraConfigLua = ''
    require("typescript-tools").setup {}
  '';
}
