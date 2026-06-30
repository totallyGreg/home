#!/bin/sh
# Curated tmux operations — single source of truth shared by the `picker` and
# `tmux-commands` tv channels.
#
# Usage:
#   picker-commands.sh             output raw: name<TAB>description<TAB>tmux-subcommand
#   picker-commands.sh formatted   output unified-picker form: "⚡  name — description ‖ subcommand"

output_raw() {
  cat <<'EOF'
break-pane	Pane → new window of its own	break-pane
join-pane-in	Pull a pane from chosen window into this one	choose-tree -Zw "join-pane -s %%"
join-pane-out	Send this pane to chosen window	choose-tree -Zw "join-pane -t %%"
swap-pane-up	Swap pane with the one above	swap-pane -U
swap-pane-down	Swap pane with the one below	swap-pane -D
kill-other-panes	Kill all other panes in this window	kill-pane -a
send-pane	Send current pane to chosen session (break-pane if same)	choose-tree -Zs "if-shell '[ \"%%\" = \"#{client_session}\" ]' 'break-pane' 'join-pane -t \"%%:\"'"
respawn-pane	Re-run this pane's original command	respawn-pane -k
clear-history	Clear scrollback for current pane	clear-history
move-window	Move window to a chosen position	choose-tree -Zw "move-window -t %%"
link-window	Mirror this window into another session	choose-tree -Zs "link-window -t %%"
swap-window	Swap this window with a chosen one	choose-tree -Zw "swap-window -s %%"
find-window	Search windows by name	command-prompt -p "find:" "find-window '%%'"
choose-tree	Native tmux session/window tree	choose-tree -Zw
kill-other-windows	Kill all windows except current	kill-window -a
next-layout	Cycle to next preset layout	next-layout
even-horizontal	Even horizontal layout (stacked rows)	select-layout even-horizontal
even-vertical	Even vertical layout (side-by-side columns)	select-layout even-vertical
main-vertical	Main pane left, others stacked right	select-layout main-vertical
main-horizontal	Main pane top, others below	select-layout main-horizontal
tiled	Tiled (grid) layout	select-layout tiled
pane-border-toggle	Toggle pane border status bar	if-shell -F '#{==:#{pane-border-status},top}' 'set pane-border-status off' 'set pane-border-status top'
kill-session	Kill current session (confirms)	confirm-before -p "kill #S? " kill-session
rename-session	Rename current session	command-prompt -I "#S" "rename-session -- '%%'"
kill-window	Kill current window (confirms)	confirm-before -p "kill window? " kill-window
rename-window	Rename current window	command-prompt -I "#W" "rename-window -- '%%'"
detach-others	Detach all other clients	detach-client -a
zoom-pane	Toggle pane zoom	resize-pane -Z
new-window	Open a new window in cwd	new-window
EOF
}

case "${1:-raw}" in
  formatted)
    # ANSI: cyan+bold ⚡ marker so the commands source is visually distinct
    # when cycled via Ctrl-S in the unified picker channel.
    output_raw | awk -F'\t' 'NF>=3 {printf "\033[36;1m⚡\033[0m  %s — %s ‖ %s\n", $1, $2, $3}'
    ;;
  *)
    output_raw
    ;;
esac
