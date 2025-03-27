function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new $(printf %q "$PREV")"
}

function pet-select() {
  BUFFER=$(pet search --color --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}

function plink() {
  # Paste link form clipboard and create a new pet snippet
  # Borrowed from https://github.com/Piotr1215/dotfiles/blob/master/.zsh_functions
  # Not working in MacOS
  link=$(pbpaste)
  desc="$*"
  if [[ -z $desc ]]; then
    echo "Provide description for link"
    return 1
  fi

  if [[ -z $link ]]; then
    echo "Provide url to link"
    return 1
  fi

  if [[ $link =~ ^https?:// ]]; then
    echo "Linking $link"
    command_name="open \\\"$link\\\""
    description="Link to $desc"
    tag="link"

  #   # Use expect to interact with pet new
  #   /usr/bin/expect <<EOF
  #     spawn pet new -t
  #     expect "Command>"
  #     send "${command_name}\r"
  #     expect "Description>"
  #     send "${description}\r"
  #     expect "Tag>"
  #     send "${tag}\r"
  #     expect eof
  # EOF
  else
    echo "Not a valid url"
    return 1
  fi
}

zle -N pet-select
stty -ixon
bindkey '^s' pet-select
