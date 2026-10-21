#!/bin/sh
# Source 0 of the M-` tmux picker (see source.sh): live tmux sessions +
# sesh configs + top-N zoxide recents, color-coded per the picker scheme.
#
#   bold green  -> live tmux sessions
#   default fg  -> sesh configs
#   dim default -> zoxide recents (capped to ZOXIDE_CAP, default 15)
#
# Solarized remaps the bright ANSI slots to its grey base tones (92 is base01,
# 37 is base2), so only the accent slots and the terminal's own fg are used:
# they stay readable in both the light and dark palettes.
#
# Coloring is applied here (not in the cable TOML) because TOML basic strings
# reject raw 0x1B bytes; doing it in shell keeps the cable file readable.

set -eu

ZOXIDE_CAP="${ZOXIDE_CAP:-15}"

# Live tmux sessions - bold green.
sesh list -t --icons | sed $'s/^/\033[1;32m/;s/$/\033[0m/'

# Sesh configs - default fg (no SGR wrap; just pass through).
sesh list -c --icons

# Zoxide recents - dim default fg, capped.
sesh list -z --icons | head -n "$ZOXIDE_CAP" | sed $'s/^/\033[2m/;s/$/\033[0m/'
