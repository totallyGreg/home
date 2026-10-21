#!/bin/sh
# Sources for the M-` tmux picker (fzf), plus its Tab/Shift-Tab stepper.
#   source.sh <0-3>                emit one source
#   source.sh step <1|-1>          print fzf actions to move to the next/prev source
# The active source is read back from $FZF_PROMPT (fzf exports it to child processes).
S=${0%/*}
names="sessions windows panes commands"
emit() {
  case $1 in
    0) "$S/sessions.sh" ;;
    1) tmux list-windows -a -F $'\033[33;1m🪟\033[0m  #{session_name}:#{window_index}  #{window_name}  [#{pane_current_command}]' ;;
    2) tmux list-panes -a -F $'\033[35;1m🧊\033[0m  #{session_name}:#{window_index}.#{pane_index}  #{pane_current_command}  [#{pane_title}]' ;;
    3) "$S/commands.sh" formatted ;;
  esac
}
if [ "$1" = step ]; then
  i=0; for n in $names; do [ "${FZF_PROMPT%%>*}" = "$n" ] && break; i=$((i + 1)); done
  i=$(( (i + $2 + 4) % 4 ))
  set -- $names; shift $i
  printf 'change-prompt(%s> )+reload-sync(%s %d)+first' "$1" "$0" "$i"
else
  emit "$1"
fi
