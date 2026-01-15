{ pkgs, ... }: {
  plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;

      # Explicitly specify which grammars to install to avoid query file errors
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        cmake
        cpp
        css
        go
        html
        javascript
        json
        lua
        markdown
        markdown_inline
        nix
        php
        python
        rust
        toml
        tsx
        typescript
        vim
        vimdoc
        yaml
        zig
      ];

      settings = {
        indent.enable = true;
        highlight.enable = true;

        # Disable auto-install to prevent local parsers
        auto_install = false;

        # Ensure parsers are managed by Nix
        ensure_installed = [];
      };
    };

    treesitter-context = {
      enable = true;
      settings = { max_lines = 1; };
    };
    # rainbow-delimiters.enable = true;
    ts-autotag.enable = true;
  };
}
