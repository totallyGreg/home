# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/totally/.local/share/nvim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/totally/.local/share/nvim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/totally/.local/share/nvim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# FZF Functions
source "$XDG_CONFIG_HOME/fzf/GITheartFZF.sh"
source "$XDG_CONFIG_HOME/fzf/Docker.sh"
source "$XDG_CONFIG_HOME/fzf/Homebrew.sh"
source "$XDG_CONFIG_HOME/fzf/Azure.sh"

# Key bindings
# ------------
source "/Users/totally/.local/share/nvim/plugged/fzf/shell/key-bindings.zsh"
source "$XDG_CONFIG_HOME/fzf/key-bindings.zsh"

# Customizations
source "$XDG_CONFIG_HOME/fzf/env"
