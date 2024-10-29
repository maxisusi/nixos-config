{
  plugins.telescope = {
    enable = true;

    settings.defaults = {
      mappings = {
        n = {
          "q".__raw =
            "require('telescope.actions').close"; # Close in normal mode
        };
      };

      sorting_strategy = "ascending";
      layout_config = {
        prompt_position = "top";
        vertical = { mirror = false; };
        width = 0.87;
        height = 0.8;
        preview_cutoff = 120;
      };

    };

    keymaps = {
      "<leader>fw" = "live_grep";
      "<leader>ff" = "find_files";
      "<leader>fb" = {
        action = "buffers";
        options = { desc = "Find buffers"; };
      };
      "<leader>fo" = {
        action = "oldfiles";
        options = { desc = "Find buffers"; };
      };

      "<C-p>" = {
        action = "git_files";
        options = { desc = "Telescope Git Files"; };
      };
    };
    extensions.fzf-native = { enable = true; };
    extensions.media-files = { enable = true; };
    extensions.ui-select = { enable = true; };
  };
}
