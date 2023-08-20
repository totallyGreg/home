# Testing out creating my own widgets
# Bind \eg to `git status`
function _git-status {
    zle kill-whole-line
    zle -U "git status"
    zle accept-line
}
zle -N _git-status
bindkey '\eg' _git-status

.toggle-watch(){
    .toggle-command-prefix 'watch ' 'watch'
}
# zle -N watch-command
zle -N .toggle-watch
bindkey '\ew' .toggle-watch     # Alt-W to toggle watch or apply to previous command

 # Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
_fix_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

# Open command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Autosuggest bindings
# bindkey '^M' autosuggest-execute # all returns accept suggestion :( 
bindkey '^u' autosuggest-execute # all returns accept suggestion :( 
bindkey '^f' forward-word
# bindkey '^I'   complete-word      # tab         | complete
bindkey '^N' autosuggest-fetch
bindkey '\el' autosuggest-clear     # N         | complete
bindkey '^I^I'   fzf-tab-complete   # double tab  | complete
# bindkey '^[[Z' autosuggest-accept # shift + tab | autosuggest
bindkey '^ ' autosuggest-accept


bindkey '\ey' jq-complete  # default is j

# Alt files
# bindkey '\e`' run "tmux split-window -p 40 'tmux send-keys -t #{pane_id} \"$(locate / | fzf -m | paste -sd\\  -)\"'"

