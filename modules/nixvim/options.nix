{
  config.opts = {
    updatetime = 100; # Faster completion

    number = true;
    relativenumber = true;

    autoindent = true;
    clipboard = "unnamedplus";
    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;

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
}
