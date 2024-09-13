# Open command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# mimic tpopes surround plugin
# although this doesn't appear to actually work
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# vi menu selections
# Removed zsh-fancy-completions which provided menuselect
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
bindkey '^[[Z' reverse-menu-complete

.toggle-watch(){
    .toggle-command-prefix 'watch ' 'watch'
    # if (( $+functions[_zsh_highlight] ))  _zsh_highlight this may be necessary for fast-syntax-highlighting
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

# Yank to the system clipboard
function vi-yank-xclip {
    zle vi-yank
   echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1
