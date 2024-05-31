{
  plugins.none-ls = {
    enable = true;
    sources = {
      formatting = {
        prettier = { enable = true; };
        nixfmt = { enable = true; };
      };
    };
  };
}
