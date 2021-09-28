# Begin Completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
# My custom completions
if [[ -d $ZDOTDIR/completions ]]; then
  fpath=($ZDOTDIR/completions $fpath)
fi

# bindkey -M menuselect '^xg' clear-screen
# bindkey -M menuselect '^xi' vi-insert                      # Insert
# bindkey -M menuselect '^xh' accept-and-hold                # Hold
# bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
# bindkey -M menuselect '^xu' undo                           # Undo

# Should be called before compinit
zmodload zsh/complist
# +---------+
# | Options |
# +---------+

# setopt GLOB_COMPLETE      # Show autocompletion menu with globs
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

## FZF tab completion
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND
# zstyle ':fzf-tab:completion:*:*:aws'
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 -G $realpath'
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup    ## This won't work until tmux 3.2 is released on homebrew
# zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
# zstyle ':fzf-tab:*' accept-line enter
# zstyle ':fzf-tab:*' continuous-trigger '/'

zstyle :completion::complete:cd::paths accept-exact-dirs true

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore completion functions for commands you don’t have:
zstyle ':completion:*:functions' ignored-patterns '_*'

# Expand partial paths
# zstyle ':completion:*' expand 'yes'
# If you end up using a directory as argument, this will remove the trailing slash (usefull in ln)
zstyle ':completion:*' squeeze-slashes true
# zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands

zstyle ':completion::complete:*' '\'

#  tag-order 'globbed-files directories' all-files
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# # Describe each match group.
# zstyle ':completion:*:descriptions' format "%B---- %d%b"

# # Messages/warnings format
# zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
# zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false

# Use colors in completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ":prezto:module:thefuck" alias "doh"
zstyle ":prezto:runcom" zpreztorc "$HOME/.config/zsh/.zshrc"

# Shows highlighted completion menu
# from https://www.reddit.com/r/zsh/comments/efi857/use_fzf_as_zshs_completion_selection_menu/
# zstyle ':completion:*:*:*:default' menu yes select search

## updated date stamp each day to invalidate the cache
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r $ZDOTDIR/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' $ZDOTDIR/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
# End of lines added by compinstall

# # Hoping to steal bash completions for free
# autoload -U +X bashcompinit &&  bashcompinit
# if type brew &>/dev/null; then
#   HOMEBREW_PREFIX="$(brew --prefix)"
#   # for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
#   completion_list=("${HOMEBREW_PREFIX}/etc/bash_completion.d/az"
#     "${HOMEBREW_PREFIX}/etc/bash_completion.d/az")
#   for COMPLETION in $completion_list; do
#     [[ -r "$COMPLETION" ]] && source "$COMPLETION"
#   done
# fi
