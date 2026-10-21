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
    # Window: its panes (* = active), then the active pane's live content
    target=$(printf '%s' "$entry" | awk -F'  ' '{print $2}')
    tmux list-panes -t "$target" -F '#{?pane_active,*, } #{pane_index}  #{pane_current_command}  #{pane_current_path}' 2>/dev/null; echo
    tmux capture-pane -t "$target" -p 2>/dev/null || printf '(no preview)\n'
    ;;
  *"⚡"*)
    # Command: show description + the actual tmux subcommand that will run
    desc=$(printf '%s' "$entry" | sed 's/.*— //;s/ ‖.*//')
    cmd=$(printf '%s' "$entry" | sed 's/.*‖ //')
    printf '%s\n\n$ tmux %s\n' "$desc" "$cmd"
    # Usage, and any key bound to exactly this command (table + key)
    printf '\n'
    tmux list-commands "${cmd%% *}" 2>/dev/null | sed 's/^/usage: /'
    tmux list-keys | awk -v c="$cmd" '{
      for (i = 1; i <= NF; i++) if ($i == "-T") break
      s = ""; for (j = i+3; j <= NF; j++) s = s (s ? " " : "") $j
      if (s == c) printf "key:   %s %s\n", $(i+1), $(i+2)
    }'
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
