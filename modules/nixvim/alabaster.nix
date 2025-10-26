{ pkgs, ... }:

let
  alabaster-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "alabaster-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "p00f";
      repo = "alabaster.nvim";
      rev = "481910715c46b83b9bf50bb9402d176391fb3017";
      sha256 = "sha256-Dfcwyi8KY2JG4jjy+Ey1YztxIv5J6SbnN8kINfzY6tk=";
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
    -- Alabaster dark theme colors
    local def_fg = "#71ADE7"      -- Functions, definitions (blue)
    local const_fg = "#CC8BC9"    -- Constants, types (purple)
    local string_fg = "#95CB82"   -- Strings (green)
    local comment_fg = "#DFDF8E"  -- Comments (yellow)
    local punct_fg = "#708B8D"    -- Punctuation (gray-blue)
    local keyword_fg = "#CECECE"  -- Keywords, variables (light gray)

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

    -- Legacy treesitter groups for compatibility
    vim.api.nvim_set_hl(0, "TSFunction", { fg = def_fg })
    vim.api.nvim_set_hl(0, "TSFuncBuiltin", { fg = def_fg })
    vim.api.nvim_set_hl(0, "TSMethod", { fg = def_fg })
    vim.api.nvim_set_hl(0, "TSConstructor", { fg = def_fg })
    vim.api.nvim_set_hl(0, "TSConstMacro", { fg = const_fg })
    vim.api.nvim_set_hl(0, "TSType", { fg = def_fg })
    vim.api.nvim_set_hl(0, "TSTypeBuiltin", { fg = def_fg })
    vim.api.nvim_set_hl(0, "TSStringRegex", { fg = string_fg })
    vim.api.nvim_set_hl(0, "TSStringEscape", { fg = string_fg })
  '';
}
