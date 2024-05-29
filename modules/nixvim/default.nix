{ pkgs, ... }:

{
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
    ./treesitter.nix
    ./lsp.nix
    ./cmp.nix
    ./neo-tree.nix
    ./autopair.nix
    ./lualine.nix
    ./telescope.nix
    ./wich_key.nix
    ./comment.nix
    ./illuminate.nix
    ./options.nix
    ./colorizer.nix
    ./lazygit.nix
    ./gitsign.nix
    ./tmux-navigator.nix
    ./leap.nix
    ./better-escape.nix
    ./notify.nix
    ./surround.nix
    ./none-ls.nix
    ./friendly-snippets.nix
    ./luasnip.nix
    ./dressing.nix
  ];

  extraPlugins = with pkgs.vimPlugins; [
    { plugin = indent-blankline-nvim; }
    { plugin = nvim-window-picker; }
  ];
  extraConfigLua =
    #lua
    ''
      -- Highlight rainbow for indentation
      local highlight = {
          "RainbowRed",
          "RainbowYellow",
          "RainbowBlue",
          "RainbowOrange",
          "RainbowGreen",
          "RainbowViolet",
          "RainbowCyan"
      }
      local hooks = require "ibl.hooks"
      hooks.register(
          hooks.type.HIGHLIGHT_SETUP,
          function()
              vim.api.nvim_set_hl(0, "RainbowRed", {fg = "#E06C75"})
              vim.api.nvim_set_hl(0, "RainbowYellow", {fg = "#E5C07B"})
              vim.api.nvim_set_hl(0, "RainbowBlue", {fg = "#61AFEF"})
              vim.api.nvim_set_hl(0, "RainbowOrange", {fg = "#D19A66"})
              vim.api.nvim_set_hl(0, "RainbowGreen", {fg = "#98C379"})
              vim.api.nvim_set_hl(0, "RainbowViolet", {fg = "#C678DD"})
              vim.api.nvim_set_hl(0, "RainbowCyan", {fg = "#56B6C2"})
          end
      )

      vim.g.rainbow_delimiters = {highlight = highlight}
      require("ibl").setup {scope = {highlight = highlight}}
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

      -- Add borders to the hover and diagnostics
      local _border = "single"
      vim.lsp.handlers["textDocument/hover"] =
          vim.lsp.with(
          vim.lsp.handlers.hover,
          {
              border = _border
          }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(
          vim.lsp.handlers.signature_help,
          {
              border = _border
          }
      )
      vim.diagnostic.config {
          float = {border = _border}
      }
      require("lspconfig.ui.windows").default_options = {
          border = _border
      }
    '';

  colorschemes = {
    dracula = {
      enable = true;
      bold = true;
      italic = true;
      underline = true;
      fullSpecialAttrsSupport = true;
      highContrastDiff = true;
      inverse = true;
      colorterm = true;
    };
  };

  autoCmd = [{
    event = [ "BufWritePre" ];
    callback = {
      __raw = "function() vim.lsp.buf.format { async = false } end";
    };
    desc = "Format on save";
  }];

  keymaps = [
    {
      key = "<C-s>";
      action = "<cmd>w!<cr>";
      options.desc = "Force write";
    }
    # Leap 
    {
      key = "Q";
      action = "<Plug>(leap-backward)";
      options.desc = "Leap backward";
    }
    {
      key = "q";
      action = "<Plug>(leap-forward)";
      options.desc = "Leap forward";
    }
    # Telescope - special commands
    {
      key = "<leader>fW";
      action =
        # lua
        ''
           function() require("telescope.builtin").live_grep {
              additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
            }
          end
        '';
      lua = true;
      options.desc = "Find words in all file";
    }
    {
      key = "<leader>fF";
      action = ''
        function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end'';
      lua = true;
      options.desc = "Find all files";
    }
    # Git Signs
    {
      key = "<leader>gh";
      action = ''function() require("gitsigns").reset_hunk() end'';
      lua = true;
      options.desc = "Reset Hunk";
    }
    {
      key = "<leader>gr";
      action = ''function() require("gitsigns").reset_buffer() end'';
      lua = true;
      options.desc = "Reset Buffer";
    }
    # Neo tree 
    {
      key = "<leader>o";
      action = "<CMD>Neotree toggle<CR>";
      options.desc = "Toggle Neo tree";
    }
    {
      key = "<leader>la";
      action = "<CMD>lua vim.lsp.buf.code_action()<CR>";
      options.desc = "Toogle Actions";
    }
    {
      key = "<leader>ld";
      action = "<CMD>lua vim.diagnostic.open_float()<CR>";
      options.desc = "Hover diagnostics";
    }
    {
      key = "<leader>gg";
      action = "<CMD>LazyGit<CR>";
      options.desc = "Open Lazygit";
    }

    # Navigation
    # -- Split Navigation
    {
      key = "|";
      action = "<CMD>vsplit<CR>";
      options.desc = "Vertical split";
    }
    {
      key = "\\";
      action = "<CMD>split<CR>";
      options.desc = "Horizontal split";
    }

    # -- Resize
    {
      key = "<C-Left>";
      action = "<CMD>vertical resize -2<CR>";
      options.desc = "Resize split vertical left";
    }
    {
      key = "<C-Right>";
      action = "<CMD>vertical resize +2<CR>";
      options.desc = "Resize split vertical right";
    }
    {
      key = "<C-Down>";
      action = "<CMD>resize +2<CR>";
      options.desc = "Resize split down";
    }
    {
      key = "<C-Up>";
      action = "<CMD>resize -2<CR>";
      options.desc = "Resize split up";
    }

    # -- Move to split
    {
      key = "<C-H>";
      action = "<C-w>h";
      options.desc = "Move to left split";
    }
    {
      key = "<C-J>";
      action = "<C-w>j";
      options.desc = "Move to below split";
    }
    {
      key = "<C-K>";
      action = "<C-w>k";
      options.desc = "Move to above split";
    }
    {
      key = "<C-L>";
      action = "<C-w>l";
      options.desc = "Move to right split";
    }
  ];
}
