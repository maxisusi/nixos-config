{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>fw" = "live_grep";
      "<leader>ff" = "find_files";
      "<leader>fb" = {
      	action = "buffers";
	options = {
	   desc = "Find buffers";
	};
      };
      "<leader>fo" = {
      	action = "oldfiles";
	options = {
	   desc = "Find buffers";
	};
      };

      "<C-p>" = {
        action = "git_files";
        options = {
          desc = "Telescope Git Files";
        };
      };
    };
    extensions.fzf-native = { enable = true; };
    extensions.media-files  = { enable = true; };
    extensions.ui-select  = { enable = true; };
  };
}
