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

complete -C /Users/totally/.asdf/installs/terraform/1.5.2/bin/terraform terraform
. "$HOME/.cargo/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/totally/.cache/lm-studio/bin"
# End of LM Studio CLI section

