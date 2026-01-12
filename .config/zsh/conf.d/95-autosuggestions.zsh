#!/bin/zsh
### Auto Suggestions
# https://github.com/zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste up-line-or-search down-line-or-search expand-or-complete accept-line push-line-or-edit)

# Fix emoji width calculation issues in autosuggestions
# These settings help zsh-autosuggestions properly calculate character widths
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Strategy for fetching suggestions
# This helps with performance and reduces rendering issues
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Buffer max size to avoid performance issues with long completions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#586e75"   # base01 (Bright Green) for Solarized dark
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#93a1a1"   # base1 (Bright Cyan) for Solarized Light
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244,bg=default,standout" # #808080 for both 
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

# ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)" # never suggest anything 50 characters or longer
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *" # never suggest anything 50 characters or longer

## Key Bindings
# This plugin provides a few widgets that you can use with bindkey:
bindkey '^ ' autosuggest-accept   # Control-space: Accepts the current suggestion.

# WARN: Tmux seems to steal both of these bindings!
bindkey '^[M' autosuggest-execute  # Alt+Return: Accepts and executes the current suggestion.
bindkey '^[[27;5;13~' autosuggest-execute # Control+Return: Accepts and executes (CSI u encoding)

bindkey '\e\e' autosuggest-clear   # : Clears the current suggestion.
bindkey '^b' autosuggest-fetch    # : Fetches a suggestion (works even when suggestions are disabled).
# bindkey '^b' autosuggest-disable  # : Disables suggestions.
# autosuggest-enable: Re-enables suggestions.
bindkey '^x'  autosuggest-toggle  # : Toggles between enabled/disabled suggestions.
# Should be called before compinit

# Autosuggest bindings
bindkey '^f' forward-word
bindkey '^I^I'   fzf-tab-complete   # double tab  | complete


# if [[ -n "$key_info" ]]; then
#   # vi
#   bindkey -M viins "$key_info[Control]F" vi-forward-word
#   bindkey -M viins "$key_info[Control]E" vi-add-eol
# fi


