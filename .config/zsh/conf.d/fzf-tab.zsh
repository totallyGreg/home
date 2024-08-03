# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# preview directory's content with lsd when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# If you're using tmux >= 3.2
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:complete:cd:*' popup-pad 30 5
zstyle ':fzf-tab:*' popup-min-size 120 30
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
¦ '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

# Solves escape code display issue: https://github.com/Aloxaf/fzf-tab/issues/24
zstyle -d ':completion:*' format
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
