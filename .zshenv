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
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/Library/Caches
export XDG_RUNTIME_HOME=$HOME/.tmp

## Ahah! Finally! This fixes "can't find stdlib.h"
export SDKROOT="`xcrun --show-sdk-path`"

# zsh
: ${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}
: ${LOCAL_ZDOTDIR:=$HOME/.local/zsh}
: ${ZSH_CACHE_DIR:=$XDG_CACHE_HOME/zsh}
ZDOTDIRS=({$ZDOTDIR,$LOCAL_ZDOTDIR}(-/N))
declare -x 'ZDOTDIR'
declare -xm 'ZSH_*'

# zsh uses $path array along with $PATH 
typeset -gU cdpath fpath mailpath path 
# path set here so non-interactive shells can use the tools
path=(
  $HOME/{,s}bin(N)
  $HOME/brew/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $HOME/.local/share/nvim/mason/bin
  $HOME/.local/bin/
  $path
)
if (hash brew > /dev/null 2>&1 ) ; then
  export HOMEBREW_PREFIX=$(brew --prefix)
  export HOMEBREW_CASK_OPTS="--appdir=~/Applications --fontdir=~/Library/Fonts"
  # Need for the tmux-exec plugin to kubectl
  export GNU_GETOPT_PREFIX="$(brew --prefix gnu-getopt)"
fi

# ASDF
export ASDF_DATA_DIR="${HOME}/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# personal bin directory
export PATH=${HOME}/bin:$PATH

[[ -d $ZDOTDIR ]] || echo Error: ZDOTDIR=${(q)ZDOTDIR} does not exist. >&2

export CARGO_HOME="$HOME/.cargo/env"
[[ -f $CARGO_HOME ]] && . $CARGO_HOME


