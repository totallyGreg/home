# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# FZF Functions
source "$XDG_CONFIG_HOME/fzf/GITheartFZF.sh"

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
source "$XDG_CONFIG_HOME/fzf/key-bindings.zsh"

