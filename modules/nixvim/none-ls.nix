{
  plugins.none-ls = {
    enable = true;
    sources = {
      formatting = {
        prettier = { enable = true; };
        nixfmt = { enable = true; };
        black = { enable = true; };
      };
    };
  };
}
