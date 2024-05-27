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
          {
            key = "<leader>gr";
            action = "<cmd>Telescope lsp_references<cr>";
          }
          {
            key = "<leader>gd";
            action = "<cmd>Telescope lsp_definitions<cr>";
          }
          {
            key = "<leader>gi";
            action = "<cmd>Telescope lsp_implementations<cr>";
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
