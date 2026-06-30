#!/bin/sh
# Dispatch preview rendering based on entry type from the `picker` tv channel.
# Action dispatch lives in the zsh `t` function — this is preview-only.
#
# Usage: picker-preview.sh "<entry>"

entry="$1"

case "$entry" in
  *"🧊"*)
    # Pane: capture content of the specific session:win.pane target
    target=$(printf '%s' "$entry" | awk -F'  ' '{print $2}')
    tmux capture-pane -t "$target" -p 2>/dev/null || printf '(no preview)\n'
    ;;
  *"🪟"*)
    # Window: capture target's live pane content
    target=$(printf '%s' "$entry" | awk -F'  ' '{print $2}')
    tmux capture-pane -t "$target" -p 2>/dev/null || printf '(no preview)\n'
    ;;
  *"⚡"*)
    # Command: show description + the actual tmux subcommand that will run
    desc=$(printf '%s' "$entry" | sed 's/.*— //;s/ ‖.*//')
    cmd=$(printf '%s' "$entry" | sed 's/.*‖ //')
    printf '%s\n\n$ tmux %s\n' "$desc" "$cmd"
    ;;
  *)
    # Sesh entry (icon-prefixed) or bare path from fd
    if [ "${entry#/}" != "$entry" ]; then
      name="$entry"
    else
      name="${entry#* }"
    fi
    sesh preview "$name" 2>/dev/null || printf '(no preview for %s)\n' "$name"
    ;;
esac
