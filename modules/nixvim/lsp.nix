{
  plugins = {
    lsp = {
      enable = true;
      servers = {
        # Javascript
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
        lspBuf = { "K" = "hover"; };
        extra = [
          {
            key = "<leader>lr";
            action.__raw = "function() vim.lsp.buf.rename() end";
          }
          {
            key = "gr";
            action = "<cmd>Telescope lsp_references<cr>";
          }
          {
            key = "gd";
            action = "<cmd>Telescope lsp_definitions<cr>";
          }
          {
            key = "gi";
            action = "<cmd>Telescope lsp_implementations<cr>";
          }
        ];
      };
    };
    lsp-format = {
      enable = true;
      setup = { options = { exclude = [ "(typescript-tools)" ]; }; };
    };
  };
}
