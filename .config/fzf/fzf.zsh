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
