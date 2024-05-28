{
  plugins.none-ls = {
    enable = true;
    sources = {
      formatting = {
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
        nixfmt = { enable = true; };
      };
    };
  };
}
