#!/usr/bin/env zsh
emulate zsh

#{{{ profiling tools # copied shamelessly from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/config/zsh/zshrc
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>$HOME/startlog.$$
  setopt xtrace prompt_subst
fi
#}}}

bindkey -v
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# History settings
# HISTFILE=~/.zsh_history   # set by /etc/zshrc
HISTSIZE=100000
SAVEHIST=100000
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

setopt SHARE_HISTORY          # share history between different instances of the shell
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_SPACE      # Remove command lines from history list when first character is a space
setopt HIST_REDUCE_BLANKS     # removes blank lines from history
setopt HIST_VERIFY            # show the substituted command in the prompt

# Changing directories
setopt AUTO_CD
setopt AUTO_PUSHD
cdpath=($HOME/Repositories)

# Other misc settings
LISTMAX=0

export FZF_DEFAULT_COMMAND='ag -l --ignore Library --ignore Music --ignore *.tagset --ignore *.photoslibrary -g ""'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -100'"

# Yes, these are a pain to customize. Fortunately, Geoff Greer made an online
# tool that makes it easy to customize your color scheme and keep them in sync
# # across Linux and OS X/*BSD at http://geoff.greer.fm/lscolors/
export LS_COLORS='no=00:fi=00:di=01;33:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:';

# eval  `dircolors -b`
export ZLS_COLORS=$LS_COLORS

# Begin Completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# The following lines were added by compinstall

# Expansion options
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle :compinstall filename '/Users/totally/.zshrc'

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

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

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Hoping to steal bash completions for free
autoload -U +X bashcompinit &&  bashcompinit
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  # for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
  completion_list=("${HOMEBREW_PREFIX}/etc/bash_completion.d/az"
    "${HOMEBREW_PREFIX}/etc/bash_completion.d/az")
  for COMPLETION in $completion_list; do
    [[ -r "$COMPLETION" ]] && source "$COMPLETION"
  done
fi

# ZPLUG Stuff - slows things down not sure I want it.
export ZPLUG_HOME=/usr/local/opt/zplug
export ZPLUG_CACHE_DIR=$ZSH_CACHE_DIR
# export ZPLUG_BIN=~/bin
source $ZPLUG_HOME/init.zsh

# NOTE: fzf-tab needs to be sourced after compinit, but before plugins which will wrap widgets like zsh-autosuggestions or fast-syntax-highlighting.
# defer:2 equals after compinit
# zplug "Aloxaf/fzf-tab", defer:2, depth:2
# zplug "RobertAudi/tsm", depth:2 # worth exploring
zplug "reegnz/jq-zsh-plugin", depth:2
# zplug "zdharma/fast-syntax-highlighting", defer:2, depth:2
# zplug 'wfxr/forgit', depth:2
# zplug 'ytet5uy4/fzf-widgets', depth:2
# https://github.com/zdharma/zflai # possibly useful logging tool
# https://github.com/unixorn/tumult.plugin.zsh # and other macos tools

# # Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# # Then, source plugins and add commands to $PATH
zplug load # --verbose

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

# fzf git functions keybindings
# -bind '"\er": redraw-current-line'
# -bind '"\C-g\C-f": "$(gf)\e\C-e\er"' # Git Files
bindkey -s '^g^b' '$(gb)' # Git Branches
# -bind '"\C-g\C-t": "$(gt)\e\C-e\er"' # Git Tags
# -bind '"\C-g\C-h": "$(gh)\e\C-e\er"' # Git history
# -bind '"\C-g\C-r": "$(gr)\e\C-e\er"' # Git Remotes

# Zsh Specific Aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias dirs='dirs -v'
alias ls='ls -G '
[ -f ~/.aliases ] && source ~/.aliases

# # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

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
fi

# Linuxbrew
# test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
# test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)


# # virtualenv
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Projects
# export PYTHONPATH=/usr/local//bin/python3
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
# [ -f /usr/local/bin/virtualenvwrapper.shi ] && source /usr/local/bin/virtualenvwrapper.sh

# Kubernetes
export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export HELM_EXPERIMENTAL_OCI=1

# Setup Go environment
export GOPATH="${HOME}/.go"
# export GOROOT="$(brew --prefix golang)/libexec"
# export GOROOT="/usr/local/go"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"


# Load FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
