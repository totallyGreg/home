# Ground truth is macOS; powerkit's toggle changes it, and USR1s every tmux zsh on change.
_appearance_sync() {
  if [[ $(defaults read -g AppleInterfaceStyle 2>/dev/null) == Dark ]]; then
    export KUBECOLOR_PRESET=dark
  else
    export KUBECOLOR_PRESET=light
  fi
  _appearance_stale=0
}

# Required: powerkit sends USR1, whose default action terminates zsh.
TRAPUSR1() { _appearance_stale=1 }

_appearance_preexec() { (( _appearance_stale )) && _appearance_sync }
autoload -Uz add-zsh-hook
add-zsh-hook preexec _appearance_preexec
_appearance_sync
