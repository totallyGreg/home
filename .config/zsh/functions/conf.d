##############################################################################
# TODO: Remove this header block
# Do NOT include function definition block (ie: omit 'function conf.d() { }').
# See: https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions
#
# Use ##? comments for help/usage docs.
##############################################################################

##? conf.d - TODO: add description here
##?
##? usage: conf.d [-h|--help]
##?        conf.d [<options>] <arguments>

#function conf.d {

local -a o_help
zmodload zsh/zutil
zparseopts -D -F -K --   {h,-help}=o_help ||
  return 1

if (( $#o_help )); then
  funchelp "conf.d"
  return
fi

# TODO: write your function here

#}

