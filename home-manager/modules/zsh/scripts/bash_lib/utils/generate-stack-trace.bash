#!/usr/bin/env bash

set -E # child scopes inherit traps
set -e # exit on errors
set -u # error on unset vars

set -o pipefail # pipes surface error code of failed constituents

trap 'LINE_OF_LAST_ERROR=$LINENO' ERR # for reporting final line of stacktrace
trap '_emit-stack-trace >&2' EXIT     # on error, emit a stacktrace
EXPLICIT_FAILURE=0                    # switch to handle if exiting because of expected or unexpected failure

_exit() {
  exit "$1"
}
_emit-stack-trace() {
  ERR_CODE="$?"
  # {{{
  # handle non-err unexpected exits like piping into head
  LINE_OF_LAST_ERROR="${LINE_OF_LAST_ERROR:--1}"
  # if [[ $- =~ e && $ERR_CODE != 0 && $LINE_OF_LAST_ERROR != '-1' ]]; then
  if [[ $- =~ e && $ERR_CODE != 0 ]]; then
    local lines calls sources
    # constructing more sane arrays of information to present on error
    lines=("${BASH_LINENO[@]:1}")
    calls=("${FUNCNAME[@]:1}")
    sources=("${BASH_SOURCE[@]:1}")

    if [[ $LINE_OF_LAST_ERROR != -1 ]]; then
      # unintentional error or `returned` non-zero
      lines=("$LINE_OF_LAST_ERROR" "${lines[@]}")
      calls=("FAILED" "${calls[@]}")
      sources=("${sources[0]}" "${sources[@]}")
    fi
    # intentional error or `exit` non-zero
    echo "callstack:"
    len=${#lines[@]}
    for ((i = 0; i < len - 1; i++)); do
      local cur_file
      cur_file="$(basename "${sources[i + 1]}")"
      local cur_call="${calls[i]}"
      local last_call="${calls[i + 1]}"
      local cur_line="${lines[$i]}"

      printf "%${i}s↳[%s] %s:%s => %s IN %s\n" "" "$i" "$cur_file" "$cur_line" "$cur_call" "$last_call"
    done

  # else
  #   echo "$ERR_CODE"
  #   echo "$-"
  #   echo "$LINE_OF_LAST_ERROR"
  fi
  # }}}

}
# helper error emission
_fatal() { # for when a fatal mistake has occurred
  # {{{
  EXPLICIT_FAILURE=1 # altered callstack generation behavior
  {
    printf "FATAL: %s\n" "$1"
    shift
    for line in "$@"; do
      printf "  %s\n" "$line"
    done
    exit 1
  } >&2
  # }}}
}
_error() {
  # {{{
  {
    printf "ERROR: %s\n" "$1"
    shift
    for line in "$@"; do
      printf "  %s\n" "$line"
    done
  } >&2
  # }}}
}
# }}}
#
# tests {{{
# unintentional-error() { #() because sometimes you want to see a stacktrace for feelgood reasons
# error() {
#     false
#   }
#   error
# }
#
# intentional-error() { #() because sometimes you want to see a stacktrace for feelgood reasons
#   error() {
#     _error 'oh boy'
#     return 1
#   }
#   error
# }
#
# intentional-exit() { #() because sometimes you want to see a stacktrace for feelgood reasons
#   error() {
#     _error 'oh boy'
#     return 1
#   }
#   error
# }
#
# intentional-deep-error() { #() because sometimes you want to see a deeper stacktrace for feelgood reasons
#   error() {
#     error-a() {
#       error-b() {
#         error-c() {
#           # return 1
#           _fatal "hashtag deep"
#         }
#         error-c
#       }
#       error-b
#     }
#     error-a
#   }
#   error
# }
#
# }}}
