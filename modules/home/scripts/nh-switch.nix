{ pkgs }:

pkgs.writeShellScriptBin "nh-switch" ''
  # Send notification that the switch is starting
  ${pkgs.libnotify}/bin/notify-send "NixOS Switch" "Starting system rebuild..." -i system-run
  
  # Run nh os switch and capture output
  OUTPUT=$(${pkgs.nh}/bin/nh os switch 2>&1)
  EXIT_CODE=$?
  
  if [ $EXIT_CODE -eq 0 ]; then
    # Success notification
    ${pkgs.libnotify}/bin/notify-send "NixOS Switch" "System rebuild completed successfully!" -i emblem-default
  else
    # Failure notification
    ${pkgs.libnotify}/bin/notify-send "NixOS Switch" "System rebuild failed!" -i dialog-error
    
    # Open kitty terminal with the error output
    echo "$OUTPUT" > /tmp/nh-switch-error.log
    ${pkgs.kitty}/bin/kitty sh -c 'echo "NixOS Switch Failed:"; echo ""; cat /tmp/nh-switch-error.log; echo ""; echo "Press any key to close..."; read -n 1; rm -f /tmp/nh-switch-error.log'
  fi
''