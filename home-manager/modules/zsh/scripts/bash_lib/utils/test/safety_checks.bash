#!/usr/bin/env bash
# this file is meant to be sourced by a bash script, running it will do nothing.
# the shebang here is strictly to provide convenient indication to your editor
# for highlighting, completion, etc.

# source adjacent context lib
set -euo pipefail
IFS=$'\n\t'
. "$LIB_PATH/utils/logs.bash"

test::safety::no_IFS_side_effects() {
	OLD_IFS="$IFS"
	reset_ifs() {
		IFS="$OLD_IFS"
	}
	trap "reset_ifs" return
	LOG_LEVEL='debug'
	local commands failed test_name
	test_name="test::safety::no_IFS_side_effects ->"
	failed='false'
	commands=("$@")
	for cmd in "${commands[@]}"; do
		# we test 2 different starting IFS to make sure the function isn't just accidentally
		# mutating IFS to the same IFS we've selected as our base.
		continue
		IFS=$'\n' && expected_ifs="$IFS"A && eval "$cmd" >/dev/null 2>&1
		[[ $expected_ifs != "$IFS" ]] && failed='true'

		IFS=$' ' && expected_ifs="$IFS"A && eval "$cmd" >/dev/null 2>&1
		[[ $expected_ifs != "$IFS" ]] && failed='true'

		if [[ $failed == 'true' ]]; then
			log::test::failure "$test_name IFS Side Effect Found in $cmd.
    expected: '$expected_ifs'
    actual: '$IFS'"
			return
		fi
	done
	if [[ $failed == 'false' ]]; then
		log::test::success "$test_name no IFS side effects found"
	fi
}
