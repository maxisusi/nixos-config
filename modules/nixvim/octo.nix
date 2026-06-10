{ pkgs, ... }:
{
  # octo.nvim — work with GitHub issues & PRs from inside Neovim.
  # Requires the `gh` CLI to be installed and authenticated (`gh auth login`).
  extraPackages = [ pkgs.gh ];

  plugins.octo = {
    enable = true;

    settings = {
      # Use telescope (already enabled) as the picker.
      picker = "telescope";
      enable_builtin = true;
      default_to_projects_v2 = true;

      # Buffer-local keymaps inside Octo buffers, remapped into the
      # `<leader>G` namespace (octo's defaults sit under `<localleader>`).
      # Note: there is no "update comment" action — edit the comment text
      # in the buffer and `:w` to push the change to GitHub.
      mappings = {
        issue = {
          add_comment.lhs = "<leader>Ga"; # add comment
          delete_comment.lhs = "<leader>Gd"; # delete comment
        };
        pull_request = {
          add_comment.lhs = "<leader>Ga"; # add comment
          delete_comment.lhs = "<leader>Gd"; # delete comment
        };
        review_thread = {
          add_comment.lhs = "<leader>Ga"; # add review comment
          add_suggestion.lhs = "<leader>Gs"; # add suggestion
          delete_comment.lhs = "<leader>Gd"; # delete comment
        };
        review_diff = {
          add_review_comment.lhs = "<leader>Ga"; # add review comment (n + visual)
          add_review_suggestion.lhs = "<leader>Gs"; # add suggestion (n + visual)
        };
      };
    };
  };

  keymaps = [
    {
      key = "<leader>Gp";
      action = "<CMD>Octo pr list<CR>";
      options.desc = "GitHub: list PRs";
    }
    {
      key = "<leader>GP";
      action = "<CMD>Octo pr search<CR>";
      options.desc = "GitHub: search PRs";
    }
    {
      key = "<leader>Gi";
      action = "<CMD>Octo issue list<CR>";
      options.desc = "GitHub: list issues";
    }
    {
      key = "<leader>GI";
      action = "<CMD>Octo issue search<CR>";
      options.desc = "GitHub: search issues";
    }
    {
      key = "<leader>Gr";
      action = "<CMD>Octo review start<CR>";
      options.desc = "GitHub: start PR review";
    }
    {
      key = "<leader>GR";
      action = "<CMD>Octo review resume<CR>";
      options.desc = "GitHub: resume PR review";
    }
    {
      key = "<leader>Gc";
      action = "<CMD>Octo pr create<CR>";
      options.desc = "GitHub: create PR";
    }
    {
      key = "<leader>Go";
      action = "<CMD>Octo pr browser<CR>";
      options.desc = "GitHub: open in browser";
    }
  ];
}
