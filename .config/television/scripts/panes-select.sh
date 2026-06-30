#!/bin/sh
# Cross-session pane jump: given "session:win.pane" target, switch the current
# client to that session, select the window, and focus the pane.
#
# Used by ~/.config/television/cable/tmux-panes.toml [actions.select].
# Factored out as a helper because doing this resolver inline in the TOML
# requires triple-nested escaping (TOML -> sh -> tmux command separators)
# that's hard to read and debug.

set -eu

target="${1:?usage: panes-select.sh session:win.pane}"
sess="${target%%:*}"
rest="${target#*:}"
win="${rest%%.*}"

tmux switch-client -t "$sess" \; \
     select-window -t "${sess}:${win}" \; \
     select-pane   -t "$target"
