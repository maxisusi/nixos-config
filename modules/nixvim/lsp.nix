{
  plugins = {
    lsp = {

      inlayHints = true;
      enable = true;

      servers = {
        eslint.enable = true;
        nixd.enable = true;
        zls.enable = true;
        cmake.enable = true;
        pylsp.enable = true;
        pylyzer.enable = true;
        gopls.enable = true;
        phpactor.enable = true;
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
      settings = {
        options = { exclude = [ "(typescript-tools)" "(intelephense)" ]; };
      };
    };
  };
}
