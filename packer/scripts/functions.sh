#!/bin/bash

send_to_screen() {
  local session="$1"
  local command="$2"

  if [ -z "$session" ] || [ -z "$command" ]; then
    echo "Usage: send_to_screen <session_name> <command>"
    return 1
  fi

  screen -S "$session" -X stuff "$command$(echo -ne '\015')"
}
