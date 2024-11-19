#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
. "$LIB_PATH/utils/logs.bash"

EXAMPLE_DARWIN_OSTYPE="darwin22.0"
EXAMPLE_LINUX_OSTYPE="linux-gnu"
alias test-boilerplate

test::cross-compat::is-linux() {
	local test_name description expectation logic actual_factual
	test_name="${FUNCNAME[0]} -> $1"
	description="$2"
	logic="$3"

	actual_factual=$(eval "$actual")
	expectation="${3##\e}"
	[[ $actual_factual == "$expectation" ]] && log::test::success "$test_name" ||
    log::test::failure \
    "$test_name
	expected: '$expectation'
	actual: '$actual_factual'"
 b1
# by default do nothing,

IS_DARWIN=""
IS_LINUX=""
[[ $OSTYPE == "darwin"* ]] &&
	IS_LINUX="" &&
	IS_DARWIN="true" &&
	run-if-linux() {
		:
	} &&
		run-if-darwin() {
			"$@"
		}
[[ $OSTYPE == "linux"*    ]] &&
	IS_LINUX="true" &&
	IS_DARWIN="" &&
	run-if-linux() {
		"$@"
	} &&
		run-if-darwin() {
			:
		}
# case "$OSTYPE" in
# 	"darwin"*)
# 		run-if-linux() {
# 			:
# 		}
# 		run-if-darwin() {
# 			"$@"
# 		}
# 		IS_DARWIN="true"
# 		;;
#
# 	"linux"*)
# 		run-if-linux() {
# 			"$@"
# 		}
# 		run-if-darwin() {
# 			:
# 		}
# 		IS_LINUX="true"
# 		;;
# 	*)
# 		printf '%s\n' "Unknown OS detected, aborting..." >&2
# 		exit 1
# 		;;
# esac
# OS=$_
#

[[ -n $IS_LINUX ]] && echo "LINUX" || echo "DARWIN"
[[ -n $IS_DARWIN ]] && echo "darwin" || echo "linux"
run-if-linux echo 'ran on linux'
run-if-darwin echo 'ran on darwin'
