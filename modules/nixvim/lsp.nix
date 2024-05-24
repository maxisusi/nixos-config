{
  plugins = {
    lsp = {
      enable = true;
      servers = {
        # Javascript
        tsserver.enable = true;
        eslint.enable = true;
        nixd.enable = true;
        zls.enable = true;
        cmake.enable = true;
        phpactor.enable = true;
        rust-analyzer = {
          installCargo = true;
          installRustc = true;
          enable = true;
        };
      };
      keymaps = {
        lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
        extra = [
          {
            key = "<leader>lr";
            action = "<CMD>LspRestart<Enter>";
          }
          {
            key = "<leader>lx";
            action = "<CMD>LspStop<Enter>";
          }
          {
            key = "<leader>ls";
            action = "<CMD>LspStart<Enter>";
          }
        ];
      };
    };
    lsp-lines = {
      enable = true;
      currentLine = true;
    };
  };
}
