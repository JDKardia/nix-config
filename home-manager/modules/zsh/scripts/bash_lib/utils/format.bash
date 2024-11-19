#!/usr/bin/env bash
# this file is meant to be sourced by a bash script, running it will do nothing.
# the shebang here is strictly to provide convenient indication to your editor
# for highlighting, completion, etc.

# source adjacent context lib
set -euo pipefail
IFS=$'\n\t'

# API:
#   format::generate_escape =>
#     purpose:
#       generate an terminal escape code given a description of escape code effect.
#     usage:
#       `format::generate_escape "$description"`
#     args:
#       `$description` -> space delimited list of tokens per TOKENS definition below.
#     example:
#       $ format::generate_escape "black on red"
#       \e[30;41m
#
#   format::reset =>
#     purpose:
#       generate an reset terminal escape code.
#     usage:
#       `format::reset`
#     example:
#       $ format::reset
#       \e[0m

#   format::text =>
#     purpose:
#       generate text formatted to match provided description.
#     usage:
#       `format::text "$text" "$description"`
#     args:
#       `$text`        -> block of text to have description applied to
#       `$description` -> space delimited list of tokens per TOKENS definition below.
#
# TEST:
#   set __ESC_PREFIX to something before executing these functions to use a custom
#   escape prefix.
#   example
#     $ __ESC_PREFIX='ESC' format::reset
#     ESC[0m

# TOKENS:
#   Each token represents one of three traits for terminal text:
#     - text rendering
#     - foreground color
#     - background color
#   these tokens are as follows:
#     Rendering     | Foreground    | Background
#     ----------------------------------------------------------------------------
#     reset         | black         | onblack
#     bold          | red           | onred
#     halfbright    | green         | ongreen
#     italic        | yellow        | onyellow
#     underline     | blue          | onblue
#     blinking      | magenta       | onmagenta
#     inverse       | cyan          | oncyan
#     hidden        | gray          | ongray
#     strikethrough | darkgray      | onbrightblack
#                   | brightred     | onbrightred
#                   | brightgreen   | onbrightgreen
#                   | brightyellow  | onbrightyellow
#                   | brightblue    | onbrightblue
#                   | brightmagenta | onbrightmagenta
#                   | brightcyan    | onbrightcyan
#                   | brightgray    | onbrightgray
#
#   for ease of use, we perform some simple preprocessing on token lists providing
#   increased readability and some useful aliases for several tokens.
#   For more detail, review format::__normalize_tokens.
#   Examples of preprocessing impact:
#     $ format::__normalize_tokens "pale black on pink"
#     halfbright black onbrightmagenta
#     $ format::__normalize_tokens "light_blue on-white "
#     brightblue onbrightgray
#

format::__normalize_tokens()  {
	# usage: format::__normalize_tokens "args"
	# purpose: de-alias and normalize user inputs into the executable tokens for formatting
	IFS=" $IFS" #join modifiers with ';'
	sed -e "
    s/light/bright/g;
    s/^on /on_/g;
    s/ on / on_/g;
    s/bright /bright_/g;
    s/_//g
    s/-//g;
    s/pale/halfbright/g;
    s/invert/inverse/g;
    s/reverse/inverse/g;
    s/strike/strikethrough/g;
    s/purple/magenta/g;
    s/teal/cyan/g;
    s/brightblack/darkgray/g;
    s/orange/brightred/g;
    s/lime/brightgreen/g;
    s/pink/brightmagenta/g;
    s/lemon/brightyellow/g;
    s/white/brightgray/g;" <<<"${*,,}"
	IFS="${IFS:1}"
}

# Background
format::generate_escape() {
	IFS=" $IFS" # for space delimited parsing

	# convert token aliases to canonical names
	local modifierNames=($(format::__normalize_tokens "$@"))

	# 'parse' escape modifier values via calls to functions matching the canonical names
	set -euo pipefail
IFS=$'\n\t'
	local modifiers=($("${modifierNames[@]}"))
	# actually generate escape code
	IFS=";$IFS" #join modifiers with ';'
	printf '%s[%sm' "${__ESC_PREFIX:=\e}" "${modifiers[*]}"
	IFS="${IFS:2}"
}

format::reset() {
	format::generate_escape "reset"
}

format::text() {
	local text=$1
	shift
	printf "%s%s%s" "$(format::generate_escape "$@")" "$text" "$(format::reset)"
}
