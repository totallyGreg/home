#!/bin/sh
# Home Brew Functions using FZF
# https://github.com/junegunn/fzf/wiki/examples

# Check this out for better fzf structure ideas
# https://github.com/thirteen37/fzf-brew/blob/master/fzf-brew.plugin.zsh

# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]lugin
bip() {
  # local preview="brew info --json=v1 {} | jq -C '.[] | {name,desc,homepage,dependencies}'"
  # local preview="brew info --json=v1 {} | jq -r '.[] | \"Name: \\(.name)\\nDescription: \\(.desc)\\nHomepage: \\(.homepage)\\nDependencies: \\(.dependencies | join(\", \"))\\n\"'"
  local preview='brew info --json=v1 {} | jq -r ".[] | \"Name: \(.name)\nDescription: \(.desc)\nHomepage: \(.homepage)\nDependencies: \(.dependencies | join(\", \"))\n\""'

  installs=($(brew formulae | fzf -m --ansi --preview "${preview}" --preview-window=:wrap --min-height=17))
  # If nothing selected just exit
  if [[ $installs ]]; then
    brew install $installs;
    brew bundle dump --all --describe --force;
  fi
}
# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]lugin
bup() {
  local preview='brew info --json=v1 {} | jq -r ".[] | \"Name: \(.name)\nDescription: \(.desc)\nVersion: \(.versions.stable)\nHomepage: \(.homepage)\nDependencies: \(.dependencies | join(\", \"))\n\""'

  # eventually, I'd like preview to show me what's changed
    # brew log --oneline --stat --max-count=2 {}"
  updates=($(brew outdated | fzf -m --ansi --min-height=20 --preview "${preview}" ))
  if [[ $updates ]]; then
    brew upgrade $updates
    brew bundle dump --all --describe --force;
  else
    echo "No updates found: $updates"
  fi
}
# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
bcp() {
  local preview="brew info --json=v1 {} | jq -C '.[] | {name,desc,homepage,dependencies}'"
  local uninst=($(brew leaves | fzf -m --ansi --preview $preview))

  if [[ $uninst ]]; then
    brew uninstall $uninst
    brew bundle dump --all --describe --force;
  fi
}
