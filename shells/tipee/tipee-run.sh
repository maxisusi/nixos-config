session_root "/home/max/Documents/dev/tipee"

if initialize_session "tipee"; then

  new_window "editor"
  run_cmd "make up && nvim ."

  new_window "devbox"
  run_cmd "zsh ./devbox"

  new_window "shell"

  # Adding aliases for the third pan only
  run_cmd "alias mu='make up'"
  run_cmd "alias md='make down'"
  run_cmd "alias mr='make restart'"
  run_cmd "alias mrb='make destroy && make up'"

  run_cmd "clear"

  # Select editor window
  select_window 0

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
