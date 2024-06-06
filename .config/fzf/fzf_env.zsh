# Setup fzf
# This gets sourced by .zshrc and then sources all my fzf configs

# FZF Functions
# Contemplating moving these to $ZDOTDIR/functions for autoload goodness
source "$XDG_CONFIG_HOME/fzf/GITheartFZF.sh"
source "$XDG_CONFIG_HOME/fzf/Docker.sh"
# source "$XDG_CONFIG_HOME/fzf/Homebrew.sh"
source "$XDG_CONFIG_HOME/fzf/Azure.sh"

export FZF_DEFAULT_COMMAND='command fd -H --no-ignore-vcs -E .git -td -tf'
# export FZF_DEFAULT_COMMAND='ag -l -t -g ""'
# export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
# export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
# export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

export FZF_DEFAULT_OPTS="
--header 'Press CTRL-Y to copy command into clipboard' \
--color header:italic \
--border sharp \
--bind '?:toggle-preview' \
--bind 'alt-a:select-all' \
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)+abort' \
--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)' \
--bind 'ctrl-v:execute(code {+})' \
--layout reverse \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒"

## Fuzzy Directory completion
export FZF_ALT_C_COMMAND='command fd -H --no-ignore-vcs -E .git -td'
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree zoxide"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --color header:italic \
  --header 'Press CTRL-/ to toggle preview' \
  --walker-skip .git,node_modules,target \
  --preview 'tree -C {}'"

# --bind ctrl-/:toggle-preview \

_fzf_compgen_path() {
  command fd -H --no-ignore-vcs -E .git -td -tf . ${1}
}

_fzf_compgen_dir() {
  command fd -H --no-ignore-vcs -E .git -td . ${1}
}

# export FZF_ALT_C_COMMAND="fd --hidden -t d . /Users/totally"
# export FZF_ALT_C_OPTS="--bind ctrl-/:toggle-preview --preview 'command ${ls_cmd} -CF {}' ${FZF_ALT_C_OPTS}"


## Fuzzy File Completion
# export FZF_CTRL_T_OPTS="--height 60% \
# --border sharp \
# --layout reverse \
# --prompt '∷ ' \
# --pointer ▶ \
# --marker ⇒"


## Popup windows when using TMUX
if [[ -n $TMUX ]] ; then
  export FZF_TMUX=1
  export FZF_TMUX_OPTS="-p 80%"
fi


## Some Color experiments
# https://vitormv.github.io/fzf-themes/
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#   --color=fg:-1,bg:-1,hl:#6c71c4
#   --color=fg+:#93a1a1,bg+:#073642,hl+:#268bd2
#   --color=info:#859900,prompt:#b58900,pointer:#6c71c4
#   --color=marker:#dc322f,spinner:#af5fff,header:#93a1a1'

# FZF Colors make no damn sense! bg+ is what I'm trying to set to base02
  # --color=fg:-1,header:#586e75,info:#cb4b16,pointer:#719e07
  # --color=marker:#719e07,fg+:#839496,prompt:#719e07,hl+:#719e07


## Fuzzy History Completion
# CTRL-R - Paste the selected command from history into the command line
# ? to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# My override that provides date and lag to the history ( `fc -rliD 1` )
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rliD 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}

zle     -N            fzf-history-widget
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget


# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}
