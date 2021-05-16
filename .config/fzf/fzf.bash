# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/totally/.local/share/nvim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/totally/.local/share/nvim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/totally/.local/share/nvim/plugged/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/totally/.local/share/nvim/plugged/fzf/shell/key-bindings.bash"
