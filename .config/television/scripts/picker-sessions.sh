#!/bin/sh
# Source for mode 1 of the tmux-actions tv channel: live tmux sessions +
# sesh configs + top-N zoxide recents, color-coded per the picker scheme.
#
#   bold bright green -> live tmux sessions
#   default white     -> sesh configs
#   dim gray          -> zoxide recents (capped to ZOXIDE_CAP, default 15)
#
# Coloring is applied here (not in the cable TOML) because TOML basic strings
# reject raw 0x1B bytes; doing it in shell keeps the cable file readable.

set -eu

ZOXIDE_CAP="${ZOXIDE_CAP:-15}"

# Live tmux sessions - bold bright green.
sesh list -t --icons | sed $'s/^/\033[1;92m/;s/$/\033[0m/'

# Sesh configs - default fg (no SGR wrap; just pass through).
sesh list -c --icons

# Zoxide recents - dim gray, capped.
sesh list -z --icons | head -n "$ZOXIDE_CAP" | sed $'s/^/\033[2;37m/;s/$/\033[0m/'
