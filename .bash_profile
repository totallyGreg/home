unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac
      export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
      ;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    FreeBSD*)   machine=FreeBSD;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Running on ${machine}"

# Auto Tmux startup/resume
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# From bash-completion@2
[[ -f /usr/local/share/bash-completion/bash_completion ]] && source "/usr/local/share/bash-completion/bash_completion"
if type brew &>/dev/null; then
  for COMPLETION in $(brew --prefix)/etc/bash_completion.d/*
  do
    [[ -f $COMPLETION ]] && source "$COMPLETION"
  done
  if [[ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ]];
  then
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  fi
fi
# Since most of my stuff is in .profile and bash will only source the first profile it finds
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"  # Load the default .profile
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"    # Load the default .bashrc
