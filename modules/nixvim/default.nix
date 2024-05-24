{pkgs, ...}:

{
  # Import all your configuration modules here
  imports = [ 
  ./bufferline.nix 
  ./treesitter.nix
  ./lsp.nix
  ./cmp.nix
  ./neo-tree.nix
  ./autopair.nix
  ./lightline.nix
  ./telescope.nix
  ./wich_key.nix
  ./comment.nix
  ./illuminate.nix
  ./options.nix
  ./colorizer.nix
  ./lazygit.nix
  ./gitsign.nix
  ];

 
  colorschemes.dracula.enable = pkgs.stdenv.isLinux;
  globals.mapleader = " ";

   keymaps = [
   {
      key = "<leader>o";
      action = "<CMD>Neotree toggle<CR>";
      options.desc = "Toggle Neo tree";
    }
    {
      key = "<C-s>";
      action = "<CMD>lua vim.lsp.buf.format()<CR>";
      options.desc = "Format the current buffer";
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


