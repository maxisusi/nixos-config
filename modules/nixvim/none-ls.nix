{
  plugins.none-ls = {
    enable = true;
    settings = { debug = true; };
    sources = {
      formatting = {
        prettier = {
          enable = true;
          # disableTsServerFormatter = true;
          # JS/TS are handled by oxfmt via conform-nvim (see oxc.nix)
          settings = {
            disabled_filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ];
          };
        };
        nixfmt = { enable = true; };
        black = { enable = true; }; # Python
        # phpcsfixer = { enable = true; }; # PHP
      };
      # diagnostics = { phpstan = { enable = true; }; };
    };
  };
}
