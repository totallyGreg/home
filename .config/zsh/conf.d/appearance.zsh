my_zac_callback() {
  local is_dark=$1

  if [[ -n "$TMUX" ]]; then
    if ((is_dark)); then
      # export FZF_DEFAULT_OPTS='--color=bg+:#1f2430,fg:#c8d3f5,hl:#82aaff'
      tmux set -g @powerkit_theme_variant "dark"
    else
      # export FZF_DEFAULT_OPTS='--color=bg+:#f2f2f2,fg:#2d2a2e,hl:#005f87'
      tmux set -g @powerkit_theme_variant "light"
    fi
    # Clear PowerKit's color cache and force re-render
    tmux run-shell "$XDG_CONFIG_HOME/tmux/plugins/tmux-powerkit/tmux-powerkit.tmux"
  fi
}
