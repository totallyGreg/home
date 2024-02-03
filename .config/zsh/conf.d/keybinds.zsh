# Open command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line


.toggle-watch(){
    .toggle-command-prefix 'watch ' 'watch'
}
# zle -N watch-command
zle -N .toggle-watch
bindkey '\ew' .toggle-watch     # Alt-W to toggle watch or apply to previous command


# Change cursor depending on mode
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

