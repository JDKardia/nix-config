#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

cd "$HOME/bin/bash_lib/"

# test files are always prefixed with 'test_' to denote that they contain tests
# so we can collect them and then run them all
for FILE_PATH in $(fd --no-ignore '^test_'); do
	echo "running '$(basename "$FILE_PATH")'"
	bash "$FILE_PATH"
	echo
done
