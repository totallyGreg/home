#!/usr/bin/env zsh
emulate zsh

#{{{ profiling tools # copied shamelessly from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/config/zsh/zshrc
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  exec 3>&2 2>$HOME/startlog.$$
  setopt xtrace prompt_subst
fi
#}}}

# Gotsta have vi bindings
export EDITOR=vim
bindkey -v

# remove list-expand binding since i can't figure out what it does and it interferes with Git heart fzf
bindkey -r '^G'

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# History settings
# HISTFILE=~/.zsh_history   # set by /etc/zshrc
HISTSIZE=99999
HISTFILESIZE=999999
SAVEHIST=$HISTSIZE
HISTORY_IGNORE='(history|ls|l|cd|cd ..|cd -|pwd|exit|date|* --help)'

setopt SHARE_HISTORY          # share history between different instances of the shell
#setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_SPACE      # Remove command lines from history list when first character is a space
setopt HIST_REDUCE_BLANKS     # removes blank lines from history
setopt HIST_VERIFY            # show the substituted command in the prompt
setopt HIST_FIND_NO_DUPS      # Duplicates are written but ignored on find
setopt INTERACTIVE_COMMENTS   # allow #style comments to be added on commandline

# Changing directories
setopt AUTO_CD
setopt AUTO_PUSHD
cdpath=($HOME/Repositories $HOME/Downloads)

# Other misc settings
LISTMAX=0


# Yes, these are a pain to customize. Fortunately, Geoff Greer made an online
# tool that makes it easy to customize your color scheme and keep them in sync
# # across Linux and OS X/*BSD at http://geoff.greer.fm/lscolors/
export LS_COLORS='no=00:fi=00:di=01;33:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:';

# eval  `dircolors -b`
export ZLS_COLORS=$LS_COLORS

# Load zsh-syntax-highlighting
# Installed with brew
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Begin Completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
# My completions
fpath=($ZDOTDIR/completions $fpath)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
# for func in $^fpath/*(N-.x:t); autoload $func
# still trying to get _stern completions to load....

zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

# The following lines were added by compinstall

# Expansion options
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
# zstyle ':completion::prefix-1:*' completer _complete
# zstyle ':completion:incremental:*' completer _complete _correct
# zstyle ':completion:predict:*' completer _complete
zstyle :compinstall filename '/Users/totally/.zshrc'

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

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false

# Use colors in completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Shows highlighted completion menu
# from https://www.reddit.com/r/zsh/comments/efi857/use_fzf_as_zshs_completion_selection_menu/
zstyle ':completion:*:*:*:default' menu yes select search

# fzf-tab-completion hint
zstyle ':completion:*' fzf-search-display true

autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
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

precmd () {
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))


    PR_FILLBAR=""
    PR_PWDLEN=""

    local promptsize=${#${(%):---(%n@%m:%l)---()--}}
    local pwdsize=${#${(%):-%~}}

    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
      ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
      PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi
}

## Source Functions
[ -f ~/.functions ] && source ~/.functions

# Zsh Specific Aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias dirs='dirs -v'
alias ls='ls -G '
alias -s {yml,yaml}=vim       # quick editing of yaml files in vim

[ -f ~/.aliases ] && source ~/.aliases

# Enable the fuck if it exists
hash thefuck > /dev/null 2>&1 && eval "$(thefuck --alias)"

# iCloud Obscured Locations
[ -d "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" ] && export iCloud="${HOME}/Clouds/iCloud"
export Books=${HOME}/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books
export Podcasts="${HOME}/Library/Group Containers/243LU875E5.groups.com.apple.podcasts"


# Homebrew
if (hash brew > /dev/null 2>&1 ) ; then
  export HOMEBREW_BUNDLE_FILE=${XDG_CONFIG_HOME}/Brewfile
  export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
  # Need for the tmux-exec plugin to kubectl
  export GNU_GETOPT_PREFIX="$(brew --prefix gnu-getopt)"
  export PATH="/usr/local/sbin:$PATH"
fi

# Linuxbrew
# test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
# test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)


# Python globally managed by pyenv
# https://opensource.com/article/19/5/python-3-default-mac#what-to-do
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Kubernetes
KUBECONFIG=$HOME/.kube/config
# kubeconfig+=$HOME/.kube/config.d/*
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export HELM_EXPERIMENTAL_OCI=1
export K9SCONFIG=$XDG_CONFIG_HOME/k9s

# Setup Go environment
export GOPATH="${HOME}/.go"
# export GOPATH="$(brew --prefix golang)"
export GOROOT="$(brew --prefix golang)/libexec"
# export GOROOT="/usr/local/go"
export PATH=$PATH:$GOPATH/bin
# path+=${GOPATH}/bin

# My stuff
PATH=${HOME}/bin:$PATH

# GPG Agent
if type gpg &>/dev/null; then
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
fi

# Unique the paths
typeset -U path fpath kubeconfig cdpath
export PATH FPATH KUBECONFIG

# Load FZF
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# ZLE custom widgets
source $ZDOTDIR/zle.zsh

# setup direnv
eval "$(direnv hook zsh)"

# setprompt
#
eval "$(starship init zsh)"

#{{{ end profiling script
if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof > ~/zshprofile$(date +'%s')
fi
#}}}

