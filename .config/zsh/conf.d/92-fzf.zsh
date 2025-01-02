# # FZF
source <(fzf --zsh)
FZF_FD_OPTS="--hidden --follow --no-ignore-vcs -E .git"
FZF_DEFAULT_COMMAND="command fd --type f $FZF_FD_OPTS"

FZF_DEFAULT_OPTS="
--header 'Press CTRL-Y to copy into clipboard | ? to toggle preview' \
--height ~100% \
--min-height=5 \
--tmux 80% \
--color header:underline \
--border sharp \
--preview-window=50%,hidden \
--bind '?:toggle-preview' \
--bind 'alt-a:select-all' \
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)+abort' \
--bind 'ctrl-e:become(echo {+} | xargs -o nvim)' \
--bind 'ctrl-v:become(code {+})' \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒"

# --layout reverse \

FZF_PREVIEW_FILE_COMMAND="bat --color=always --paging=never --style=plain"
FZF_PREVIEW_DIR_COMMAND="tree -C {}"

FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree zoxide"
# FZF_ALT_C_OPTS="--ansi --preview \"$FZF_PREVIEW_DIR_COMMAND {} 2>/dev/null\""
FZF_ALT_C_OPTS="
  --color header:bold \
  --header 'Press ? to toggle preview' \
  --walker-skip .git,node_modules,target \
  --preview \"$FZF_PREVIEW_DIR_COMMAND {} 2>/dev/null\"
  "
FZF_ALT_C_COMMAND="fd --type d . $FZF_FD_OPTS"

# FZF_CTRL_T_OPTS="--ansi --bind \"ctrl-w:execute(\${EDITOR:-nano} {1} >/dev/tty </dev/tty)+refresh-preview\" --preview \"$FZF_PREVIEW_FILE_COMMAND {} 2>/dev/null\""
FZF_CTRL_T_OPTS="
  --walker-skip '.git,node_modules,target'
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
