#!/bin/zsh
### Auto Suggestions
# https://github.com/zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste up-line-or-search down-line-or-search expand-or-complete accept-line push-line-or-edit)

## Key Bindings

# This plugin provides a few widgets that you can use with bindkey:

# autosuggest-accept: Accepts the current suggestion.
# autosuggest-execute: Accepts and executes the current suggestion.
# autosuggest-clear: Clears the current suggestion.
# autosuggest-fetch: Fetches a suggestion (works even when suggestions are disabled).
# autosuggest-disable: Disables suggestions.
# autosuggest-enable: Re-enables suggestions.
# autosuggest-toggle: Toggles between enabled/disabled suggestions.
# For example, this would bind ctrl + space to accept the current suggestion.

# bindkey '^ ' autosuggest-accept
# bindkey '^ ' forward-word
# Should be called before compinit



# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#586e75"   # base01 (Bright Green) for Solarized dark
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#93a1a1"   # base1 (Bright Cyan) for Solarized Light
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244,bg=default,standout" # #808080 for both 
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

if [[ -n "$key_info" ]]; then
  # vi
  bindkey -M viins "$key_info[Control]F" vi-forward-word
  bindkey -M viins "$key_info[Control]E" vi-add-eol
fi

# Autosuggest bindings
# bindkey '^M' autosuggest-execute # all returns accept suggestion :( 
bindkey '^u' autosuggest-execute # all returns accept suggestion :( 
bindkey '^f' forward-word
# bindkey '^I'   complete-word      # tab         | complete
bindkey '^N' autosuggest-fetch
bindkey '\el' autosuggest-clear     # N         | complete
bindkey '^I^I'   fzf-tab-complete   # double tab  | complete
# bindkey '^[[Z' autosuggest-accept # shift + tab | autosuggest
bindkey '^ ' autosuggest-accept

