{
  plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      indent = true;
      ensureInstalled = [ "typescript" ];
    };

    treesitter-context.enable = true;
    rainbow-delimiters.enable = true;
  };
}
