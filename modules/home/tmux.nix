{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.sensible
    ];
    extraConfig = ''
      # Unbind default C-b command
            unbind C-b
            set -g prefix C-a

      # Set vi mode-keys on copy mode
            setw -g mode-keys vi
            bind -T copy-mode-vi v send -X begin-selection
            bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
            bind P paste-buffer
            bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      # Fixing strikethrough not appearing on tmux with neovim
            set -g default-terminal "xterm-kitty"
            set -ga terminal-overrides ",xterm-256color:Tc,alacritty:RGB"
            set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      # Reload config
            unbind r
            bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded..."

      # Set new panes to open in current directory
            bind c new-window -c "#{pane_current_path}"
            bind '"' split-window -c "#{pane_current_path}"
            bind % split-window -h -c "#{pane_current_path}"

      # Restoring clear screen
            bind C-l send-keys 'C-l'

      # Resize with mouse
            setw -g mouse on
    '';
  };
}
