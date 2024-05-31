{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [{ plugin = vim-visual-multi; }];
}
