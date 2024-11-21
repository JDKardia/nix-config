#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
# this file is meant to be sourced by a bash script, running it will do nothing.
# the shebang here is strictly to provide convenient indication to your editor
# for highlighting, completion, etc.

# source adjacent context lib
set -euo pipefail
IFS=$'\n\t'
. "$LIB_PATH/utils/logs.bash"
. "$LIB_PATH/utils/format.bash"
. "$LIB_PATH/utils/test/safety_checks.bash"

test::format::escape_generation() {
	local test_name description actual expectation
	test_name="test::format::escape_generation -> $1"
	description="$2"
	actual="format::generate_escape '$description'"
	actual_factual=$(eval "$actual")
	actual_factual="${actual_factual##\e}"
	expectation="${3##\e}"
	[[ $actual_factual == "$expectation" ]] && log::test::success "$test_name"
	[[ $actual_factual == "$expectation" ]] || log::test::failure "$test_name
	expected: $actual => '$expectation'
	actual: $actual => '$actual_factual'"
}

test::format::token_normalization() {
	local test_name description actual_factual expectation
	test_name="test::format::token_normalization -> $1"
	description="$2"
	actual="format::__normalize_tokens '$description'"
	actual_factual=$(eval "$actual")
	expectation="${3}"
	[[ $actual_factual == "$expectation" ]] && log::test::success "$test_name"
	[[ $actual_factual == "$expectation" ]] || log::test::failure "$test_name
    expected: $actual => '$expectation'
      actual: $actual => '$actual_factual'"
}

test::format::escape_generation "verify reset" "reset" "\e[0m"
test::format::escape_generation "verify escape generation" "bold blue on bright red" "\e[1;34;101m"

test::format::token_normalization "should lowercase" "BOLD" "bold"
test::format::token_normalization "should handle spaces for 'on' and 'bright'" "black on bright blue" "black onbrightblue"
test::format::token_normalization "should ignore '-' and '_'" "dark_gray on-bright-blue" "darkgray onbrightblue"
test::format::token_normalization "should handle spaces for 'on' and 'bright'" "BOLD" "bold"
test::format::token_normalization "should convert aliases" \
	"lightblue pale invert reverse strike purple teal brightblack orange lime lemon pink white" \
	"brightblue halfbright inverse inverse strikethrough magenta cyan darkgray brightred brightgreen brightyellow brightmagenta brightgray"

test::safety::no_IFS_side_effects \
	"format::__normalize_tokens 'blue'" \
	"format::generate_escape 'blue'" \
	"format::reset" \
	"format::text 'blue' 'blue'"
