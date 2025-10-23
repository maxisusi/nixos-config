{
  plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        indent.enable = true;
        highlight.enable = true;
      };
    };

    treesitter-context = {
      enable = true;
      settings = { max_lines = 1; };
    };
    # rainbow-delimiters.enable = true;
    ts-autotag.enable = true;
  };
}
