{ pkgs, ... }:

let
  alabaster-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "alabaster-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "p00f";
      repo = "alabaster.nvim";
      rev = "76ee17c34f13190d1a3532613c7ca946303f0ffe";
      sha256 = "sha256-U4MCkhJNKQWPVE5HC0zK6bU3ZMg4DQnheEqjAqxoGcQ=";
    };
  };
in {
  extraPlugins = [ alabaster-nvim ];

  colorscheme = "alabaster";

  opts = {
    background = "dark"; # Use dark background for dark alabaster theme
  };

  globals = {
    # Plugin configuration options  
    alabaster_dim_comments =
      false; # Keep comments bright (false = bright, true = dim)
    alabaster_floatborder = false; # Default floating window border styling
  };

  # Comprehensive treesitter color fixes to match alabaster dark theme
  extraConfigLua = ''
    -- Function to apply alabaster highlights
    local function apply_alabaster_highlights()
      -- Alabaster dark theme colors
      local def_fg = "#71ADE7"      -- Functions, definitions (blue)
      local const_fg = "#CC8BC9"    -- Constants, types (purple)
      local string_fg = "#95CB82"   -- Strings (green)
      local comment_fg = "#DFDF8E"  -- Comments (yellow)
      local punct_fg = "#708B8D"    -- Punctuation (gray-blue)
      local keyword_fg = "#CECECE"  -- Keywords, variables (light gray)

    -- Core treesitter groups that must be set
    vim.api.nvim_set_hl(0, "@comment", { fg = comment_fg })
    vim.api.nvim_set_hl(0, "@string", { fg = string_fg })
    vim.api.nvim_set_hl(0, "@string.documentation", { fg = string_fg })
    vim.api.nvim_set_hl(0, "@number", { fg = const_fg })
    vim.api.nvim_set_hl(0, "@boolean", { fg = const_fg })
    vim.api.nvim_set_hl(0, "@constant", { fg = const_fg })
    vim.api.nvim_set_hl(0, "@constant.builtin", { fg = const_fg })
    vim.api.nvim_set_hl(0, "@keyword", { fg = keyword_fg })
    vim.api.nvim_set_hl(0, "@keyword.return", { fg = keyword_fg })
    vim.api.nvim_set_hl(0, "@keyword.operator", { fg = keyword_fg })
    vim.api.nvim_set_hl(0, "@variable", { fg = keyword_fg })
    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = keyword_fg })
    vim.api.nvim_set_hl(0, "@variable.parameter", { fg = keyword_fg })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = punct_fg })
    vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = punct_fg })

    -- Fix function-related groups (should be blue)
    vim.api.nvim_set_hl(0, "@function", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@function.builtin", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@function.call", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@function.macro", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@method", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@method.call", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@constructor", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@keyword.function", { fg = def_fg })

    -- Fix constant-related groups (should be purple)
    vim.api.nvim_set_hl(0, "@constant.macro", { fg = const_fg })

    -- Fix type definitions (should be blue like functions)
    vim.api.nvim_set_hl(0, "@type", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = def_fg })
    vim.api.nvim_set_hl(0, "@type.definition", { fg = def_fg })

    -- Fix string-related groups (should be green)
    vim.api.nvim_set_hl(0, "@string.regex", { fg = string_fg })
    vim.api.nvim_set_hl(0, "@string.escape", { fg = string_fg })

    -- LSP Semantic Token highlights (these override treesitter)
    vim.api.nvim_set_hl(0, "@lsp.type.comment", { link = "@comment" })
    vim.api.nvim_set_hl(0, "@lsp.type.string", { link = "@string" })
    vim.api.nvim_set_hl(0, "@lsp.type.number", { link = "@number" })
    vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = "@variable" })
    vim.api.nvim_set_hl(0, "@lsp.type.parameter", { link = "@variable.parameter" })
    vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "@function" })
    vim.api.nvim_set_hl(0, "@lsp.type.method", { link = "@method" })
    vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "@variable" })
    vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "@type" })
    vim.api.nvim_set_hl(0, "@lsp.type.interface", { link = "@type" })
    vim.api.nvim_set_hl(0, "@lsp.type.enum", { link = "@type" })
    vim.api.nvim_set_hl(0, "@lsp.type.type", { link = "@type" })
    vim.api.nvim_set_hl(0, "@lsp.type.keyword", { link = "@keyword" })

      -- Legacy treesitter groups for compatibility
      vim.api.nvim_set_hl(0, "TSComment", { fg = comment_fg })
      vim.api.nvim_set_hl(0, "TSString", { fg = string_fg })
      vim.api.nvim_set_hl(0, "TSFunction", { fg = def_fg })
      vim.api.nvim_set_hl(0, "TSFuncBuiltin", { fg = def_fg })
      vim.api.nvim_set_hl(0, "TSMethod", { fg = def_fg })
      vim.api.nvim_set_hl(0, "TSConstructor", { fg = def_fg })
      vim.api.nvim_set_hl(0, "TSConstMacro", { fg = const_fg })
      vim.api.nvim_set_hl(0, "TSType", { fg = def_fg })
      vim.api.nvim_set_hl(0, "TSTypeBuiltin", { fg = def_fg })
      vim.api.nvim_set_hl(0, "TSStringRegex", { fg = string_fg })
      vim.api.nvim_set_hl(0, "TSStringEscape", { fg = string_fg })
    end

    -- Apply highlights immediately
    apply_alabaster_highlights()

    -- Re-apply highlights after colorscheme loads
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "alabaster",
      callback = apply_alabaster_highlights,
      desc = "Apply alabaster highlight fixes after colorscheme loads"
    })

    -- Re-apply highlights after LSP attaches (to override semantic tokens)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        vim.defer_fn(apply_alabaster_highlights, 100)
      end,
      desc = "Re-apply alabaster highlights after LSP attaches"
    })
  '';
}
