{
  plugins.none-ls = {
    enable = true;
    settings = { debug = true; };
    sources = {
      formatting = {
        prettier = { enable = true; };
        nixfmt = { enable = true; };
        black = { enable = true; }; # Python
        # phpcsfixer = { enable = true; }; # PHP
      };
      # diagnostics = { phpstan = { enable = true; }; };
    };
  };
}
