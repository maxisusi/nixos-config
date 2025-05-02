{ pkgs, color_scheme, ... }:

{
  # Import all your configuration modules here
  imports = [
    # ./illuminate.nix
    # ./friendly-snippets.nix
    # ./coq-nvim.nix
    # ./better-escape.nix
    ./bufferline.nix
    ./treesitter.nix
    ./lsp.nix
    # ./cmp.nix
    ./neo-tree.nix
    ./autopair.nix
    ./lualine.nix
    ./telescope.nix
    ./wich_key.nix
    ./comment.nix
    ./options.nix
    ./colorizer.nix
    ./lazygit.nix
    ./gitsign.nix
    ./tmux-navigator.nix
    ./leap.nix
    ./notify.nix
    ./surround.nix
    ./none-ls.nix
    ./luasnip.nix
    ./dressing.nix
    ./indent-blankline.nix
    ./vim-visual-multi.nix
    ./typescript-tools.nix
    ./copilot.nix
    ./mini.nix
    ./dap.nix
    ./rust-tools.nix
    ./spectre.nix
    { plugins.web-devicons = { enable = true; }; }
    {
      plugins.blink-cmp = {
        enable = true;
        settings = {
          completion = {
            accept = {
              auto_brackets = {
                enabled = true;
                semantic_token_resolution.enabled = false;
              };
            };
            documentation.auto_show = true;
          };
          appearance = {
            use_nvim_cmp_as_default = true;
            nerd_font_variant = "normal";
          };
        };
      };
    }
    { plugins.cmake-tools = { enable = true; }; }
  ];

  extraPlugins = with pkgs.vimPlugins; [{ plugin = nvim-window-picker; }];
  extraConfigLua =
    #lua
    ''
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
    catppuccin = {
      enable = true;
      settings = {
        flavour = color_scheme;
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          notify = true;
        };
      };
    };
  };

  autoCmd = [{
    event = [ "CursorMoved" ];
    callback = {
      __raw =
        #lua
        ''
          function()
              if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
                  vim.schedule(
                      function()
                          vim.cmd.nohlsearch()
                      end
                  )
              end
          end
        '';
      desc = "remove search highlight when done";
    };
  }];

  keymaps = [
    {
      key = "<leader>dB";
      action.__raw =
        #lua
        ''
          function() require("dap").clear_breakpoints() end
        '';
      options.desc = "Clear breakpoint";
    }
    {
      key = "<leader>db";
      action.__raw =
        #lua
        ''
          function() require("dap").toggle_breakpoint() end
        '';
      options.desc = "Toggle breakpoint";
    }
    {
      key = "<leader>do";
      action.__raw =
        #lua
        ''
          function() require("dapui").toggle() end
        '';
      options.desc = "Toggle debugger";
    }
    # Typescript tools
    {
      key = "<leader>ru";
      action = "<cmd>TSToolsRemoveUnusedImports<cr>";
      options.desc = "Remove unused imports";
    }
    {
      key = "<leader>ai";
      action = "<cmd>TSToolsAddMissingImports<cr>";
      options.desc = "Add missing imports";
    }
    {
      key = "<leader>pp";
      action = "<cmd>TSToolsOrganizeImports<cr>";
      options.desc = "Organize imports";
    }
    {
      key = "<C-s>";
      action = "<cmd>w!<cr>";
      options.desc = "Force write";
    }
    # Leap 
    # Disabling because I want to learn how to use marcros in vim 
    # {
    #   key = "Q";
    #   action = "<Plug>(leap-backward)";
    #   options.desc = "Leap backward";
    # }
    # {
    #   key = "q";
    #   action = "<Plug>(leap-forward)";
    #   options.desc = "Leap forward";
    # }
    # Telescope - special commands
    {
      key = "<leader>ls";
      action.__raw =
        # lua
        ''
          function() require("telescope.builtin").lsp_document_symbols() end
        '';
      options.desc = "Search symbols";
    }
    {
      key = "<leader>gC";
      action.__raw =
        # lua
        ''
          function() require("telescope.builtin").git_bcommits { use_file_path = true } end
        '';
      options.desc = "Git commits (current file)";
    }
    {
      key = "<leader>gc";
      action.__raw =
        # lua
        ''
          function() require("telescope.builtin").git_commits { use_file_path = true } end         
        '';
      options.desc = "Git commits (repository)";
    }
    {
      key = "<leader>f<CR>";
      action.__raw =
        # lua
        ''
          function() require("telescope.builtin").resume() end        
        '';
      options.desc = "Resume previous search";
    }
    {
      key = "<leader>f/";
      action.__raw =
        # lua
        ''
          function() require("telescope.builtin").current_buffer_fuzzy_find() end 
        '';
      options.desc = "Find words in the current buffer";
    }
    {
      key = "<leader>gt";
      action.__raw =
        # lua
        ''
          function() require("telescope.builtin").git_status { use_file_path = true } end
        '';
      options.desc = "Git status";
    }
    {
      key = "<leader>fW";
      action.__raw =
        # lua
        ''
           function() require("telescope.builtin").live_grep {
              additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
            }
          end
        '';
      options.desc = "Find words in all file";
    }
    {
      key = "<leader>fF";
      action.__raw = ''
        function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end'';
      options.desc = "Find all files";
    }
    # Git Signs
    {
      key = "<leader>to";
      action = "<CMD>Gitsigns blame<CR>";
      options.desc = "Stage Hunk";
    }
    {
      key = "<leader>gh";
      action.__raw = ''function() require("gitsigns").reset_hunk() end'';
      options.desc = "Reset Hunk";
    }
    {
      key = "<leader>gr";
      action.__raw = ''function() require("gitsigns").reset_buffer() end'';
      options.desc = "Reset Buffer";
    }
    # Yazi 
    {
      key = "<leader>o";
      action = "<CMD>Yazi<CR>";
      options.desc = "Toggle Yazi";
    }
    {
      key = "<leader>cw";
      action = "<CMD>Yazi cwd<CR>";
      options.desc = "Open the file manager in nvim's working directory";
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
