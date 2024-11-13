# Open command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Surrounds from https://thevaluable.dev/zsh-line-editor-configuration-mouseless/
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km -- $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km -- $c select-bracketed
  done
done

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
# zle -N change-surround surround
# bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

bindkey '^[[Z' reverse-menu-complete  # enable shift-tab

function _watch-command {
  # if buffer is empty, load previous command
  [[ -z $BUFFER ]] && zle up-history
  # zle _expand_alias
  # zle expand-word
  # zle end-of-buffer-or-history
  # if buffer doesn't already contain watch, prepend the watch command to the buffer
  [[ ! $BUFFER =~ '^watch.*' ]] && BUFFER="watch -c $BUFFER"
  # kubecolor needs to have --force-colors since it can't tell if watch supports it
  [[ $BUFFER =~ 'kubecolor.*' ]] && BUFFER="$BUFFER --force-colors"
  zle end-of-line
}
zle -N _watch-command
bindkey '\ew' _watch-command     # Alt-W to append watch or apply to previous command

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
