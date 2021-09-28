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

## Now sourcing completions
source $ZDOTDIR/completion.zsh

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

# ASDF to manage various versions of cli binaries
# if command -v asdf 1>/dev/null 2>&1; then
#   $(brew --prefix asdf)/libexec/asdf.sh
# fi
zinit ice src="asdf.sh" atinit'zpcompinit; zpcdreplay' nocd
zinit load asdf-vm/asdf
zinit cdclear -q

### Starship prompt
zinit ice from"gh-r" as"program" atload'!eval $(starship init zsh)'
zinit light starship/starship
