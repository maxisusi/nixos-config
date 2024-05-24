{
  config = {
    opts = {
      updatetime = 100; # Faster completion

      number = true;
      relativenumber = true;

      autoindent = true;
      clipboard = "unnamedplus";
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      cursorline = true; # highlight the text line of the cursor
      history = 100; # number of commands to remmeber in a history table
      tabstop = 2;
      wrap = false; # disable line wrapping

      ignorecase = true; # case insensitive searching
      incsearch = true;
      smartcase = true;
      wildmode = "list:longest";
      mouse = "a"; # enable mouse support
      showmode = false; # disable showing modes on command line in favor of Lualine

      undofile = true; # Build-in persistent undo
      termguicolors = true; # enable 24-bit RGB color in the TUI
      timeoutlen = 500; # shorten key timeout length a little bit for which-key
      cmdheight = 0; # hide command line unless needed
    };
    globals = {
      mapleader = " "; # set the leader key
    };
  };
}
