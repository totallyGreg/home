
# Show extended information when completing files
zstyle ':completion:*' file-list all

zstyle ':completion::complete:cd::paths' accept-exact-dirs true

# Overide .zcomet/repos/mattmc3/zephyr/plugins/completion/functions/compstyle_zephyr_setup
# since it doesn't rener properly
zstyle ':completion:*' format ' %F{blue}-- %d --%f'

# from the valuable dev
zstyle ':completion:*' completer _extensions _complete _approximate

# setting consistent cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
