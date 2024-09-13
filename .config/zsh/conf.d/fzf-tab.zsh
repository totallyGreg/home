zstyle ':fzf-tab:*' prefix '' # default value adds a period in front of selections
# Solves color escape code display issue: https://github.com/Aloxaf/fzf-tab/issues/24
zstyle -d ':completion:*' format
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'


# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

bindkey -M viins '^F' toggle-fzf-tab

## If you're using tmux >= 3.2
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:*' popup-min-size 120 20
#
# zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
# fzf-preview 'echo ${(P)word}'

# zstyle ':fzf-tab:complete:-command-:*' fzf-preview ¦ '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'
# zstyle ':fzf-tab:complete:-command-:*' fzf-flags '--preview=hidden --preview-window=down,10,wrap'

# To disable or override preview for command options and subcommands
# zstyle ':fzf-tab:complete:*:options' fzf-preview
# zstyle ':fzf-tab:complete:*:argument-1' fzf-preview

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

zstyle ':fzf-tab:complete:kubectl:-values-:*' fzf-preview 'kubectl $word --help'
zstyle ':fzf-tab:complete:kubectl:*' fzf-preview 'kubectl explain $word'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview 'whence -v $word'
zstyle ':fzf-tab:complete:-command-:*' fzf-flags '--preview-window=top:1:hidden:wrap'
# zstyle ':fzf-tab:complete:kubectl:*' fzf-flags '--preview=hidden'
# zstyle ':fzf-tab:complete:export:*' fzf-flags '--preview-window=top:20%:wrap --border bottom'

zstyle ':fzf-tab:complete:ssh:argument_rest' fzf-preview '[[ $group == "[host]"]] && dig $word'
zstyle ':fzf-tab:complete:ssh:hosts' fzf-preview 'dig $word'

# This appears to be broken https://github.com/Aloxaf/fzf-tab/issues/466
# zstyle ':fzf-tab:complete:cd:*:local-directories' fzf-preview 'tree -C {}'
# preview directory's content with lsd when completing cd
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
#
# Disabled due to it constantly throwing directory drwxr-xr-x into the query
zstyle ':fzf-tab:complete:cd:*' disabled-on any


# fzf-tab won't parse FZF_DEFAULT_OPTS, you have to do this manually.
# zstyle ':fzf-tab:complete:*' fzf-preview 'bat $realpath'
zstyle ':fzf-tab:complete:*' fzf-flags --preview-window 50%,hidden:wrap

