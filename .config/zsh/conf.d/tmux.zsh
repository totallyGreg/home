# small tmux sessionizer: quickly create, attach, or switch tmux sessions
t() {
  # helpers
  has_session_exact() {
    tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -qx "$1"
  }
  attach_or_switch() {
    local session_name="$1"
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$session_name" || echo "Error: Could not switch to session '$session_name'."
    else
      tmux attach-session -t "$session_name" || echo "Error: Could not attach to session '$session_name'."
    fi
  }
  tmux_create_and_attach() {
    tmux new-session -d -s "$session_name" && t "$session_name" || echo "Error: Failed to create session '$session_name'."
  }
  usage() {
      echo "Usage: t [session_name]"
      echo ""
      echo "  session_name (optional):"
      echo "    - An exact session name to attach or switch to."
      echo "    - A new session name to create and attach in the current directory."
      echo ""
      echo "  Notes:"
      echo "    - Use TAB to complete session names."
      echo "    - No argument creates or attaches to a session (based on the current directory)."
  }

  # MAIN LOGIC
  # more than 1 parameter provided
  if [[ "$#" -gt 1 ]]; then
    usage && return 1
  fi

  # one parameter provided
  if [[ "$#" -eq 1 ]]; then
    local session_name="$1"
    if has_session_exact $session_name; then
      attach_or_switch $session_name
    else # we don't have that session
      tmux_create_and_attach
    fi
    return
  fi

  # no parameter provided
  local session_name="$(basename "$(pwd)")"
  if has_session_exact $session_name; then
    attach_or_switch $session_name
  else
    tmux_create_and_attach
  fi
}

_t_complete() {
    local -a _sessions _descriptions
    IFS=$'\n'
    _sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
    _descriptions=($(tmux list-sessions 2>/dev/null))
    compadd -d _descriptions -a _sessions
}
compdef _t_complete t