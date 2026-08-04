{ ... }: {
  # ponytail: only the prefix differs from herdr's defaults (see `herdr
  # --default-config`), so declare that one key. Read-only symlink means the
  # in-app settings panel (prefix+s) can't persist writes; edit this file instead.
  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [keys]
    prefix = "ctrl+a"
  '';
}
