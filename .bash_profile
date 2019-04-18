# Since most of my stuff is in .profile and bash will only source the first profile it finds

export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# From bash-completion@2
[[ -f /usr/local/share/bash-completion/bash_completion ]] && source "/usr/local/share/bash-completion/bash_completion"
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"  # Load the default .profile
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"    # Load the default .bashrc

# Auto Tmux startup/resume
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi
