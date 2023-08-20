# Begin Completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
# # My custom completions
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

## FZF tab completion using Aloxaf/fzf-tab
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'

# zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND
# zstyle ':fzf-tab:completion:*:*:aws'
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup    ## This won't work until tmux 3.2 is released on homebrew
# zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
# zstyle ':fzf-tab:*' accept-line enter
# zstyle ':fzf-tab:*' continuous-trigger '/'

zstyle :completion::complete:cd::paths accept-exact-dirs true

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Fuzzy matching of completions for when you mistype them:
# zstyle ':completion:*' completer _complete _match _approximate
# zstyle ':completion:*:match:*' original only
# zstyle ':completion:*:approximate:*' max-errors 1 numeric

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

zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false

# Use colors in completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ":prezto:module:thefuck" alias "doh"
zstyle ":prezto:runcom" zpreztorc "$HOME/.config/zsh/.zshrc"

# # Hoping to steal bash completions for free
autoload -U +X bashcompinit &&  bashcompinit
# if type brew &>/dev/null; then
#   HOMEBREW_PREFIX="$(brew --prefix)"
#   # for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
#   completion_list=("${HOMEBREW_PREFIX}/etc/bash_completion.d/az"
#     "${HOMEBREW_PREFIX}/etc/bash_completion.d/az")
#   for COMPLETION in $completion_list; do
#     [[ -r "$COMPLETION" ]] && source "$COMPLETION"
#   done
# fi
