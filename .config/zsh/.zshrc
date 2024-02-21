#!/usr/bin/env zsh
PROFILE_STARTUP=false

if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>$HOME/startlog.$$
  setopt xtrace prompt_subst
fi

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

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# # History settings
# # HISTFILE=~/.zsh_history   # set by /etc/zshrc
# HISTSIZE=500000
# HISTFILESIZE=999999
# SAVEHIST=$HISTSIZE
# HISTORY_IGNORE='(history|ls|l|cd|cd ..|cd -|pwd|exit|date|*xyzzy*|* --help)'

# ## Mutually Exclusive, choose one
# # setopt SHARE_HISTORY           # share history between different instances of the shell
# # setopt INC_APPEND_HISTORY      # Write to the history file immediately, not when the shell exits.
# setopt INC_APPEND_HISTORY_TIME # history entry is written out to the file after the command is finished, so that the time taken by the command is recorded correctly in the history file in EXTENDED_HISTORY format.


# # History
# # http://zsh.sourceforge.net/Doc/Release/Options.html#History
# setopt append_history          # append to history file
# setopt extended_history        # write the history file in the ':start:elapsed;command' format
# unsetopt hist_beep             # don't beep when attempting to access a missing history entry
# setopt hist_expire_dups_first  # expire a duplicate event first when trimming history
# setopt hist_find_no_dups       # don't display a previously found event
# setopt hist_ignore_all_dups    # delete an old recorded event if a new event is a duplicate
# setopt hist_ignore_dups        # don't record an event that was just recorded again
# setopt hist_ignore_space       # don't record an event starting with a space
# setopt hist_no_store           # don't store history commands
# setopt hist_reduce_blanks      # remove superfluous blanks from each command line being added to the history list
# setopt hist_save_no_dups       # don't write a duplicate event to the history file
# setopt hist_verify             # don't execute immediately upon history expansion
# setopt inc_append_history      # write to the history file immediately, not when the shell exits
# setopt interactive_comments    # allow #style comments to be added on commandline
# setopt share_history           # don't share history between all sessions

# Changing Directories
# http://zsh.sourceforge.net/Doc/Release/Options.html#Changing-Directories
setopt auto_cd                 # if a command isn't valid, but is a directory, cd to that dir
setopt auto_pushd              # make cd push the old directory onto the directory stack
setopt pushd_ignore_dups       # don’t push multiple copies of the same directory onto the directory stack
setopt pushd_minus             # exchanges the meanings of ‘+’ and ‘-’ when specifying a directory in the stack
# setopt cdablevars
cdpath=($HOME $HOME/Repositories $HOME/Downloads $HOME/Work)

# iCloud Obscured Locations
if [ -d "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" ]; then
  export iCloud="${HOME}/Clouds/iCloud"
  hash -d iCloud=~/Library/Mobile\ Documents/com\~apple\~CloudDocs
  hash -d audiobooks=~/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books/audiobooks
  hash -d books=~/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/Books
  hash -d obsidian=~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents
  hash -d podcasts=~/Library/Group\ Containers/243LU875E5.groups.com.apple.podcasts
  hash -d accounts="/Users/totally/greg.williams@solo.io - Google Drive/Shared drives/Field/Customer Success/Account Activity"
fi

# Other misc settings
LISTMAX=0

# Yes, these are a pain to customize. Fortunately, Geoff Greer made an online
# tool that makes it easy to customize your color scheme and keep them in sync
# # across Linux and OS X/*BSD at http://geoff.greer.fm/lscolors/
export LS_COLORS='no=00:fi=00:di=01;33:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:';

# eval  `dircolors -b`
export ZLS_COLORS=$LS_COLORS

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

# Apple Xcode Path
if [ -d /Library/Developer/CommandLineTools/usr/bin ] ; then
  export PATH=/Library/Developer/CommandLineTools/usr/bin:$PATH
  export CC=$(xcrun --find clang)
  export CXX=$(xcrun --find clang++)
fi

# OpenSSL that generates valid 
if [ -d /usr/local/opt/openssl@3/bin ] ; then
  export PATH="/usr/local/opt/openssl@3/bin:$PATH"
fi

# Setup Go environment
export GOPATH="${HOME}/Work/go"
# export GOROOT="$(brew --prefix golang)/libexec"
export GOROOT=~/.local/share/golang
export PATH="$PATH:${GOPATH}/bin"
export CGO_CFLAGS="-g -O2 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
# export PATH="$PATH:${GOROOT}/bin" # Not needed with brew install go

# Cargo
PATH=${HOME}/.cargo/bin:$PATH
# From https://braindetour.com/article/20220213 but still getting linker errors
# export PATH=$PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib # Needed for Rust compilation and linking
# export LIBRARY_PATH=$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib # Needed for Rust compilation and linking

# Rancher-Desktop
PATH=${HOME}/.rd/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# Kubernetes
set_kubeconfig () {
  typeset -xT KUBECONFIG kubeconfig       # tie scalar and array together making adding easier
  KUBECONFIG="$HOME/.kube/config"         # many tools assume only this file or it is first in path

  # List of common directories that contain kubeconfig files to add to my KUBECONFIG
  local kube_dirs=(
  ${HOME}/.kube/config.d
  ${HOME}/.kube/eksctl/clusters
  ${HOME}/.k3d
  ${HOME}/.kube/gke
)
  # This will create a list of config files located in $kube_dir
  # while ignoring any errors (directories that don't exist)
  kubeConfigFileList=$(find ${kube_dirs} -type f 2>/dev/null)
  # for file in $(ls -d -1 $HOME/.lima/*/conf/kubeconfig.yam)
  #   do kubeConfigFileList+=$file
  # done

  # Combine all file paths into the single `KUBECONFIG` path variable.
  while IFS= read -r kubeConfigFile; do
    kubeconfig+="${kubeConfigFile}"
  done <<< ${kubeConfigFileList}

  # This appears necessary to join it back into a PATH type variable
  # KUBECONFIG=${(j.:.)kubeconfig}
}
set_kubeconfig

set_kubeconfig_shell() {
  # Create a unique KUBECONFIG for the shell
  export KUBECONFIG="$HOME/.kube/config-$(uuidgen)"
  cp $HOME/.kube/config "$KUBECONFIG"
  trap "rm $KUBECONFIG" EXIT
}

export KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export HELM_EXPERIMENTAL_OCI=1
export K9SCONFIG=$XDG_CONFIG_HOME/k9s

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

# Session Sauce variable
typeset -TUx SESS_PROJECT_ROOT sess_project_root
sess_project_root=(~/Work/Customers)

# Zsh Specific Aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias dirs='dirs -v'
alias -s {yml,yaml}=vim       # quick editing of yaml files in vim

[ -f ~/.aliases ] && source ~/.aliases

## Source Functions after aliases
## Autoload functions you might want to use with antidote.
# ZFUNCDIR=${ZFUNCDIR:-$ZDOTDIR/functions}
# fpath=($ZFUNCDIR $fpath)
# autoload -Uz $fpath[1]/*(.:t)

# [ -f ~/bin/ExpressVPN.sh ] && source ~/bin/ExpressVPN.sh
# [ -f $ZDOTDIR/solo.sh ] && source $ZDOTDIR/solo.sh

# Source zstyles you might use with antidote.
# [[ -e ${ZDOTDIR:-~}/zstyles ]] && source ${ZDOTDIR:-~}/zstyles

# Enable the fuck if it exists, this adds 0.6s to each shell start
# hash thefuck > /dev/null 2>&1 && eval "$(thefuck --alias doh)"

eval "$(direnv hook zsh)"

######
# # Clone antidote if necessary.
# zstyle ':antidote:bundle' use-friendly-names on
# [[ -d ${ZDOTDIR:-~}/.antidote ]] ||
#   git clone https://github.com/mattmc3/antidote ${ZDOTDIR:-~}/.antidote

# # Create an amazing Zsh config using antidote plugins.
# source ${ZDOTDIR:-~}/.antidote/antidote.zsh
# antidote load

# # Install fzf binary if not found
# # This directory is cloned in zsh_plugin.txt binary is added to path and default key-bindings and completions are set
# if ! [[ -e "$(antidote home)/junegunn/fzf/bin/fzf" ]]
# then
#   antidote load
#   "$(antidote home)/junegunn/fzf/install" --bin
# fi
#######

## Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

# Source zcomet.zsh
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

# Install Fzf
zcomet load junegunn/fzf shell completion.zsh key-bindings.zsh
( (( ${+commands[fzf]} )) || ~[fzf]/install --bin ) && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf_env.zsh


# My FZF based configuration and extra functions
# (( ${+commands[fzf]} )) && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf_env.zsh

## Load some plugins
zcomet load zsh-users/zsh-completions
zcomet load mattmc3/zephyr plugins/completion
zcomet load asdf-vm/asdf
zcomet load mattmc3/zephyr plugins/color
zcomet load mattmc3/zephyr plugins/homebrew
zcomet load mattmc3/zephyr plugins/macos
zcomet load mattmc3/zephyr plugins/zfunctions
zcomet load Aloxaf/fzf-tab
zcomet load reegnz/jq-zsh-plugin  # Interactive jq explorer

#
# zcomet load xPMo/zsh-toggle-command-prefix # keeps throwing sudo errors 
# zcomet load starship/starship
# zcomet load kubermatic/fubectl # https://github.com/kubermatic/fubectl
# zcomet load ChrisPenner/session-sauce

# Lazy-load some plugins
zcomet trigger zhooks agkozak/zhooks
# zcomet trigger zsh-prompt-benchmark romkatv/zsh-prompt-benchmark

# This breaks all kinds of aliases and who knows what else
# But I really must steal the security keychain bits
# zinit light unixorn/tumult.plugin.zsh

## These plugins which will wrap widgets prefer to be last
zcomet load zdharma-continuum/fast-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions
zcomet load mattmc3/zephyr plugins/confd     # autosuggestions wants the keybinds after the plugin has been installed

# Set custom fast syntax highlighting work directory
FAST_WORK_DIR=XDG

# Since google is doing their own test of whether or not to add completions instead of adding to fpath
# It has to be added after the compinit is compiled
# The next line enables shell command completion for gcloud.
if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ];
  then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc";
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc";
fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Run compinit and compile its cache
zcomet compinit

### Starship prompt
eval "$(starship init zsh)"

# source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"

if [[ "$PROFILE_STARTUP" == true ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-; zprof > ~/zshprofile$(date +'%s')
fi
