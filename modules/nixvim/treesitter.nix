{
  plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      indent = true;
      ensureInstalled = "all";
    };

    treesitter-context.enable = true;
    rainbow-delimiters.enable = true;
    ts-autotag.enable = true;
  };
}
