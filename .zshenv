#!/usr/bin/env zsh
# Just for my own notes / confirmation and to help anybody else, the ultimate order is
# .zshenv
# → [.zprofile if login]
# → [.zshrc if interactive]
# → [.zlogin if login]
# → [.zlogout sometimes]
#

# Poorly setup machines will often forget this
export LC_CTYPE=en_US.UTF-8

# XDG Base Directory Specification https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/Library/Caches
export XDG_RUNTIME_HOME=$HOME/.tmp

# zsh
: ${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}
: ${LOCAL_ZDOTDIR:=$HOME/.local/zsh}
: ${ZSH_CACHE_DIR:=$XDG_CACHE_HOME/zsh}
ZDOTDIRS=({$ZDOTDIR,$LOCAL_ZDOTDIR}(-/N))
declare -x 'ZDOTDIR'
declare -xm 'ZSH_*'
export PATH=/opt/homebrew/bin:$PATH

[[ -d $ZDOTDIR ]] || echo Error: ZDOTDIR=${(q)ZDOTDIR} does not exist. >&2

