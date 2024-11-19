#!/usr/bin/env bash
# this file is meant to be sourced by a bash script, running it will do nothing.
# Sourcing this file will:
#
#
#   * Set sane defaults for script execution, plus the slightly insane default of expanding
#       aliases, as I like to use them for metaprogramming.
#   * Set Variables for simpler, safe scripting:
#      * LIB_PATH      -> Path to script library
#      * IS_DARWIN     -> 'true' if run on MacOS, empty if on linux
#      * IS_LINUX      -> 'true' if run on Linux, empty if on MacOS
#   * Set Functions for simpler, safer scripting:
#      * run-on-darwin     -> execute function with following variables if on Macos
#      * run-on-linux      -> execute function with following variables if on linux
#   * Set Aliases for simpler and fun scripting, no safety guarantees here:
#      * is-darwin      -> evaluates and provides return values of 0 if darwin, 1 if linux
#      * is-linux      -> evaluates and provides return values of 0 if linux, 1 if darwin
#      * term-is-pipe -> evaluates and provides return values of 0 if tty is pipe and 1 otherwise
#      * has-no-args -> evaluates and provides return values of 0 if $# is 0 and 1 otherwise
#   * Provide a consistent $PATH variable that guarantees system-common binaries are found in the path first
#

# Bash Safe Mode {{{
if [[ ${#CUSTOM_SETTINGS[@]} -eq 0 ]]; then
  set -o nounset
  set -o pipefail
  set -o errexit
else
  for setting in "${CUSTOM_SETTINGS[@]}"; do
    eval "$setting"
  done
fi
# required, cannot disable
shopt -s expand_aliases

IFS=$'\n\t'
# }}}
#
# Helpers {{{
# ___(){} # function to allow more complex aliases and handle 'command not found'
alias term-is-pipe='[[ ! -t 0 ]]'
alias stdin-is-pipe='[[ ! -t 0 ]]'
alias stdout-is-pipe='[[ ! -t 1 ]]'
alias stderr-is-pipe='[[ ! -t 2 ]]'
alias stdin-is-tty='[[ -t 0 ]]'
alias stdout-is-tty='[[ -t 1 ]]'
alias stderr-is-tty='[[ -t 2 ]]'
alias has-no-args='[[ $# == 0 ]]'
alias has-args='[[ $# != 0 ]]'
alias all-args-are-files='__() { for x in "$@"; do [[ -f "$x" ]] || return 1; done;} && __ "$@"'
alias args-into-pipe="{ IFS=\$'\n' && printf '%s\\n' \"\$@\" ;}"
# }}}

# System Specific Programming {{{
[[ $OSTYPE == "darwin"* ]] && alias is-darwin="true" && alias is-linux="false"
[[ $OSTYPE == "linux"*  ]] && alias is-darwin="false" && alias is-linux="true"

is-darwin && IS_DARWIN="true" && IS_LINUX=""
is-linux  && IS_DARWIN="" && IS_LINUX="true"

is-darwin && run-on-linux() {
  :
}
is-linux  && run-on-linux() {
  "$@"
}

is-darwin && run-on-darwin() {
  "$@"
}
is-linux  && run-on-darwin() {
  :
}
# }}}

# Path Setup {{{
LIB_PATH="$HOME/bin/bash_lib/"
DARWIN_PATH=(
  "$HOME/bin"
  # Guarantee most common utilities are gnu, not bsd
  /opt/homebrew/opt/coreutils/libexec/gnubin
  /opt/homebrew/opt/findutils/libexec/gnubin
  /opt/homebrew/opt/gnu-sed/libexec/gnubin
  /opt/homebrew/opt/gnu-tar/libexec/gnubin
  /opt/homebrew/opt/gnu-time/libexec/gnubin
  /opt/homebrew/opt/gnu-units/libexec/gnubin
  /opt/homebrew/opt/gnu-xargs/libexec/gnubin
  /opt/homebrew/opt/grep/libexec/gnubin
  /opt/homebrew/opt/gawk/libexec/gnubin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/MacGPG2/bin
  "$HOME/.nodenv/shims"
  "$HOME/.local/bin"
  "$HOME/.local/share/cargo/bin"
  "$HOME/.local/share/go/bin"
  "$HOME/.local/share/pyenv/shims"
  "$HOME/.rbenv/shims"
  "$HOME/stripe/space-commander/bin"
  "$HOME/stripe/work/exe"
  "$HOME/.local/share/asdf/shims"
  "$HOME/.config/zsh/plugins/.asdf/bin"
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /Applications/kitty.app/Contents/MacOS
)

LINUX_PATH=(
  "$HOME/bin"
  "$HOME/.nodenv/shims"
  "$HOME/.local/bin"
  "$HOME/.local/share/cargo/bin"
  "$HOME/.local/share/go/bin"
  "$HOME/.local/share/pyenv/shims"
  "$HOME/.rbenv/shims"
  "$HOME/stripe/space-commander/bin"
  "$HOME/stripe/work/exe"
  "$HOME/.local/share/asdf/shims"
  "$HOME/.config/zsh/plugins/.asdf/bin"
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
)

IFS=':'
is-darwin && PATH="${DARWIN_PATH[*]}"
is-linux && PATH="${LINUX_PATH[*]}"
IFS=$'\n\t'
# }}}
