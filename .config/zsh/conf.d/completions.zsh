# Show extended information when completing files
# completion - String acting as a namespace, to avoid pattern collisions with other scripts also using zstyle.
# <function> - Apply the style to the completion of an external function or widget.
# <completer> - Apply the style to a specific completer. We need to drop the underscore from the completer’s name here.
# <command> - Apply the style to a specific command, like cd, rm, or sed for example.
# <argument> - Apply the style to the nth option or the nth argument. It’s not available for many styles.
# <tag> - Apply the style to a specific tag.

# :completion:<function>:<completer>:<command>:<argument>:<tag>

# This needs to be loaded AFTER compinit and thus here.
compdef kubecolor=kubectl

# setting consistent cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

zstyle ':completion:*' file-list all

zstyle ':completion::complete:cd::paths' accept-exact-dirs true

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# set descriptions format to enable group support
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
# Here, -command- means any word in the “command position”. It means that we want the matches tagged alias to appear before builtins, functions, and commands.
# This does not appear to change when fzf-tab is involved
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

# # Group matches and describe.  as defined by zsh-fancy-completions
# zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
# zstyle ':completion:*:corrections' format ' %F{green}»» %d (errors: %e) ««%f'
# zstyle ':completion:*:descriptions' format ' %F{cyan}»» %d ««%f'
# zstyle ':completion:*:messages' format ' %F{purple} »» %d ««%f'
# zstyle ':completion:*:warnings' format ' %F{red}»» no matches found ««%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# zstyle ':completion:*' format ' %F{yellow}»» %d ««%f'

zstyle ':completion:*' verbose yes

# Overide .zcomet/repos/mattmc3/zephyr/plugins/completion/functions/compstyle_zephyr_setup
# since it doesn't render properly
# zstyle ':completion:*' format ' %F{blue}-- %d --%f'

# Skip setting stupid aliases
zstyle ':zephyr:plugin:color:alias' skip true
