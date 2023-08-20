# Setup fzf
# This gets sourced by .zshrc and then sources all my fzf configs
# ---------
if [[ ! "$PATH" == *$XDG_DATA_HOME/nvim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$XDG_DATA_HOME/nvim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$XDG_DATA_HOME/nvim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# FZF Functions
source "$XDG_CONFIG_HOME/fzf/GITheartFZF.sh"
source "$XDG_CONFIG_HOME/fzf/Docker.sh"
source "$XDG_CONFIG_HOME/fzf/Homebrew.sh"
source "$XDG_CONFIG_HOME/fzf/Azure.sh"
source "$XDG_CONFIG_HOME/fzf/kubernetes.sh"

# Key bindings
# ------------
source "$XDG_DATA_HOME/nvim/plugged/fzf/shell/key-bindings.zsh"
# source "$XDG_CONFIG_HOME/fzf/key-bindings.zsh"

# Customizations
source "$XDG_CONFIG_HOME/fzf/env"

# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rliD 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
