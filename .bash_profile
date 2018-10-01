# Since most of my stuff is in .profile and bash will only source the first profile it finds

# From bash-completion@2
[[ -f /usr/local/share/bash-completion/bash_completion ]] && source "/usr/local/share/bash-completion/bash_completion"
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"  # Load the default .profile
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"    # Load the default .bashrc
