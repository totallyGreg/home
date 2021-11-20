# Setup fzf
# ---------
if [[ ! "$PATH" == *$XDG_DATA_HOME/nvim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$XDG_DATA_HOME/nvim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/totally/.local/share/nvim/plugged/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/totally/.local/share/nvim/plugged/fzf/shell/key-bindings.bash"
source "$XDG_CONFIG_HOME/fzf/key-bindings.bash"

# Customizations
source "$XDG_CONFIG_HOME/fzf/env"
