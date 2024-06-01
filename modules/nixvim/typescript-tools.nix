{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [{ plugin = typescript-tools-nvim; }];
  extraConfigLua =
    # lua
    ''
      require("typescript-tools").setup {
        settings = {
          tsserver_plugins = {
            -- for TypeScript v4.9+
            "@styled/typescript-styled-plugin",
            -- or for older TypeScript versions
            -- "typescript-styled-plugin",
          },
        },
      }
    '';
}
