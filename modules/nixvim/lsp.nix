{
  plugins = {
    lsp = {
      enable = true;
      servers = {
        tsserver.enable = true;
        nixd.enable = true;
        eslint.enable = true;
        zls.enable = true;
        cmake.enable = true;
        phpactor.enable = true;
      };
      keymaps.lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };
    };
    lsp-lines = {
      enable = true;
      currentLine = true;
    };
  };
}
