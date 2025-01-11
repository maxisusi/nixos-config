{
  plugins = {
    cmp_luasnip = { enable = true; };
    cmp-nvim-lsp = { enable = true; };
    cmp-buffer = { enable = true; };
    cmp-path = { enable = true; }; # file system paths
    cmp-cmdline = { enable = false; }; # autocomplete for cmdline

    cmp = {
      enable = true;
      settings = {
        snippet = {
          expand =
            "function(args) require('luasnip').lsp_expand(args.body) end";
        };
        formatting = {
          fields = [ "kind" "abbr" "menu" ];
          format =
            # lua
            ''
              function(_, item)
                local icons = {
                  Namespace = "󰌗",
                  Text = "󰉿",
                  Method = "󰆧",
                  Function = "󰆧",
                  Constructor = "",
                  Field = "󰜢",
                  Variable = "󰀫",
                  Class = "󰠱",
                  Interface = "",
                  Module = "",
                  Property = "󰜢",
                  Unit = "󰑭",
                  Value = "󰎠",
                  Enum = "",
                  Keyword = "󰌋",
                  Snippet = "",
                  Color = "󰏘",
                  File = "󰈚",
                  Reference = "󰈇",
                  Folder = "󰉋",
                  EnumMember = "",
                  Constant = "󰏿",
                  Struct = "󰙅",
                  Event = "",
                  Operator = "󰆕",
                  TypeParameter = "󰊄",
                  Table = "",
                  Object = "󰅩",
                  Tag = "",
                  Array = "[]",
                  Boolean = "",
                  Number = "",
                  Null = "󰟢",
                  String = "󰉿",
                  Calendar = "",
                  Watch = "󰥔",
                  Package = "",
                  Copilot = "",
                  Codeium = "",
                  TabNine = "",
                }

                local icon = icons[item.kind] or ""
                item.kind = string.format("%s ", icon) 
                return item
              end
            '';
        };
        window = {
          completion = {
            border = "rounded";
            winhighlight =
              "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None";
          };
          documentation = {
            border = "rounded";
            winhighlight =
              "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None";
          };
        };
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
          }
          {
            name = "luasnip";
            priority = 800;
          }
          {
            name = "buffer";
            priority = 500;
          }
          {
            name = "path";
            priority = 250;
          }
        ];
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-n>" =
            "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
          "<C-p>" =
            "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
          "<S-CR>" =
            "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        };
      };

    };
  };
}
