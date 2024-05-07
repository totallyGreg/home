
# Show extended information when completing files
zstyle ':completion:*' file-list all


zstyle :completion::complete:cd::paths accept-exact-dirs true

# Overide .zcomet/repos/mattmc3/zephyr/plugins/completion/functions/compstyle_zephyr_setup
# since it doesn't rener properly
zstyle ':completion:*' format ' %F{blue}-- %d --%f'

