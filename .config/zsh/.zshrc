#!/usr/bin/env zsh
emulate zsh

# Gotsta have vi bindings
export EDITOR=nvim
bindkey -v

# Yank to the system clipboard
function vi-yank-xclip {
    zle vi-yank
   echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# remove list-expand binding since i can't figure out what it does and it interferes with Git heart fzf
bindkey -r '^G'

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# History settings
# HISTFILE=~/.zsh_history   # set by /etc/zshrc
HISTSIZE=99999
HISTFILESIZE=999999
SAVEHIST=$HISTSIZE
HISTORY_IGNORE='(history|ls|l|cd|cd ..|cd -|pwd|exit|date|*xyzzy*|* --help)'

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
cdpath=($HOME $HOME/Repositories $HOME/Downloads $HOME/Work)

# Other misc settings
LISTMAX=0

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
# My custom completions
if [[ -d $ZDOTDIR/completions ]]; then
  fpath=($ZDOTDIR/completions $fpath)
fi

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
[ -f $ZDOTDIR/solo ] && source $ZDOTDIR/solo

# Enable the fuck if it exists
# hash thefuck > /dev/null 2>&1 && eval "$(thefuck --alias)"

# iCloud Obscured Locations
[ -d "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" ] && export iCloud="${HOME}/Clouds/iCloud"
export Books=${HOME}/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books
export Podcasts="${HOME}/Library/Group Containers/243LU875E5.groups.com.apple.podcasts"

# Homebrew
if [ -d /opt/homebrew ] ; then
  export PATH=/opt/homebrew/bin:$PATH
fi
if (hash brew > /dev/null 2>&1 ) ; then
  export HOMEBREW_PREFIX=$(brew --prefix)
  export HOMEBREW_BUNDLE_FILE=${XDG_CONFIG_HOME}/Brewfile
  export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
  # Need for the tmux-exec plugin to kubectl
  export GNU_GETOPT_PREFIX="$(brew --prefix gnu-getopt)"
  export PATH="${HOMEBREW_PREFIX}/sbin:$PATH"
fi

# Linuxbrew
# test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
# test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Python globally managed by pyenv
# https://opensource.com/article/19/5/python-3-default-mac#what-to-do
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi


# ASDF to manage various versions of cli binaries
# if command -v asdf 1>/dev/null 2>&1; then
#   $(brew --prefix asdf)/libexec/asdf.sh
# fi

# Kubernetes
set_kubeconfig () {
  KUBECONFIG=$HOME/.kube/config
  # Lists of kubeconfig directories to add to my KUBECONFIG
  local configd="${HOME}/.kube/config.d"
  local eks_clusters="${HOME}/.kube/eksctl/clusters"
  local k3d="${HOME}/.k3d"
  mkdir -p ${configd} ${eks_clusters}
  kubeConfigFileList=$(find ${configd} ${eks_clusters} ${k3d} -type f)

  # Combine all file paths into the single `KUBECONFIG` variable.
  while IFS= read -r kubeConfigFile; do
    KUBECONFIG+=":${kubeConfigFile}"
  done <<< ${kubeConfigFileList}
}
set_kubeconfig

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export HELM_EXPERIMENTAL_OCI=1
export K9SCONFIG=$XDG_CONFIG_HOME/k9s

# Setup Go environment
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Cargo
PATH=${HOME}/.cargo/bin:$PATH

# My stuff
PATH=${HOME}/bin:$PATH

# GPG Agent
if type gpg &>/dev/null; then
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
else
  # echo "GPG not found using ssh-agent"
fi

# Unique the paths
typeset -U path fpath kubeconfig cdpath
export PATH FPATH KUBECONFIG

# Load FZF
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# ZLE custom widgets
source $ZDOTDIR/zle.zsh

## setprompt with starship if it exists
# hash starship > /dev/null 2>&1 && eval "$(starship init zsh)"

### Added by Zinit's installer
if [[ ! -f $HOME/.config/zsh/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.config/zsh/.zinit" && command chmod g-rwX "$HOME/.config/zsh/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.config/zsh/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.config/zsh/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# zinit light zdharma/zui
# zinit light zdharma/zplugin-crasis
zinit light Aloxaf/fzf-tab
zinit light xPMo/zsh-toggle-command-prefix

# Fancy new for-syntax
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload'_zsh_autosuggest_start; bindkey "^[[Z" autosuggest-accept'\
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions
# zinit ice wait"0a" lucid atload'_zsh_autosuggest_start; bindkey "^ " autosuggest-accept;'
# zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
# bindkey '^M' autosuggest-execute  # unfortunatley this isn't control return just return
# bindkey '^I'   complete-word      # tab          | complete
# bindkey '^I^I'   fzf-tab-complete # double tab          | complete
# bindkey '^[[Z' autosuggest-accept # shift + tab  | autosuggest

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; 
then 
  . "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  zinit ice blockf if'[[ "$(uname)" == "Darwin" ]]'
  zinit snippet $HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

zinit ice wait'1' lucid
zinit light laggardkernel/zsh-thefuck
# This breaks all kinds of aliases and who knows what else
# But I really must steal the security keychain bits
# zinit light unixorn/tumult.plugin.zsh

zinit from"gh-r" as"program" mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
    pick"direnv" src="zhook.zsh" for \
        direnv/direnv

### Starship prompt
zinit ice from"gh-r" as"program" atload'!eval $(starship init zsh)'
zinit light starship/starship
