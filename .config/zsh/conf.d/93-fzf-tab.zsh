# FZF-TAB
## https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file
zstyle ':fzf-tab:*' prefix '' # default value adds a period in front of selections
# Solves color escape code display issue: https://github.com/Aloxaf/fzf-tab/issues/24
zstyle -d ':completion:*' format
# WARN: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'

# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-min-height 10

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

# when completing  environment variables, show their values (wrapped)
# in the preview window ("<unset>" if no value/empty string)
# zstyle ":fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*" fzf-flags "--preview-window=wrap" "${FZF_TAB_DEFAULT_FZF_FLAGS[@]}"
# zstyle ":fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*" fzf-preview "[[ -n \${(P)word} ]] && echo \${(P)word} || echo \<unset\>"

zstyle ':fzf-tab:complete:kubectl:-values-:*' fzf-preview 'kubectl $word --help'
zstyle ':fzf-tab:complete:kubectl:*' fzf-preview 'kubectl explain $word'
# zstyle ':fzf-tab:complete:kubectl:*' fzf-flags '--preview=hidden'
# zstyle ':fzf-tab:complete:export:*' fzf-flags '--preview-window=top:20%:wrap --border bottom'

zstyle ':fzf-tab:complete:ssh:argument_rest' fzf-preview '[[ $group == "[host]"]] && dig $word'
zstyle ':fzf-tab:complete:ssh:hosts' fzf-preview 'dig $word'

# This appears to be broken https://github.com/Aloxaf/fzf-tab/issues/466
# zstyle ':fzf-tab:complete:cd:*:local-directories' fzf-preview 'tree -C $realpath'
# preview directory's content with lsd when completing cd
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'tree -C $realpath'
#
# Disabled due to it constantly throwing directory drwxr-xr-x into the query
# zstyle ':fzf-tab:complete:cd:*' disabled-on any  NOTE: turns off broken cd completion

# zstyle ':completion::complete:*:*:directories' fzf-preview 'tree -d $word'

# fzf-tab won't parse FZF_DEFAULT_OPTS, you have to do this manually.
zstyle ':fzf-tab:complete:-command-:*' fzf-preview 'whence -v $word'
zstyle ':fzf-tab:complete:-parameter-:*' fzf-preview 'echo $word'
zstyle ':fzf-tab:complete:-command-:*' fzf-flags --preview-window=top:1:hidden:wrap --min-height=5 --bind '?:toggle-preview'

# Borrowed from https://github.com/byjpr/dot/blob/61cbb3e81e12fa5e0ca6ad1624791a97dd764b5f/zsh/custom/plugins.zsh#L144
# zstyle ':fzf-tab:*' fzf-command fzf
# zstyle ':fzf-tab:*' fzf-flags '--ansi'
# zstyle ':fzf-tab:*' fzf-bindings \
#   'tab:accept' \
#   'ctrl-y:execute-silent(echo {+} | pbcopy)+abort' \
#   'shift-p:preview-page-up' \
#   'shift-n:preview-page-down' \
#   'ctrl-e:execute-silent(\${VISUAL:-code} \$realpath >/dev/null 2>&1)' \
#   'ctrl-w:execute(\${EDITOR:-nano} \$realpath >/dev/tty </dev/tty)+refresh-preview'
# zstyle ':fzf-tab:*' fzf-min-height 10
#
# zstyle ':fzf-tab:complete:man:*' fzf-preview \
#   'man -P \"col -bx\" \$word | $FZF_PREVIEW_FILE_COMMAND --language=man'
# zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview \
#   'brew info \$word'
# zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview \
#   'echo \${(P)word}'
# zstyle ':fzf-tab:complete:*:options' fzf-preview
# zstyle ':fzf-tab:complete:*:options' fzf-flags '--no-preview'
# zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
# zstyle ':fzf-tab:complete:*:argument-1' fzf-flags '--no-preview'
# zstyle ':fzf-tab:complete:*:*' fzf-preview \
#   '($FZF_PREVIEW_FILE_COMMAND \$realpath || $FZF_PREVIEW_DIR_COMMAND \$realpath) 2>/dev/null'
