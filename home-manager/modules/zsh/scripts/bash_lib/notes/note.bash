#!/usr/bin/env bash

# simple and shitty library for managing my personal notes.

note::access() {
	# If the note exists, lets open it up to edit it
	# $1 = path to note
	nvim "$1.md"
	exit 0
}

note::create() {
	# If the note does NOT exist, lets initialize it.
	# $1 = title of note
	# $2 = path to note
	local title="$1"
	local file_path="$2.md"
	local ref=$(mktemp)
	echo "$1" >"$ref"
	echo "$1" | sed 's/./=/g' >>"$ref"
	cp "$ref" "$file_path"
	echo >>"$file_path"
	echo >>"$file_path"
	nvim -c '+ normal G' "$file_path"
	[ "" == "$(diff -wB "$ref" "$file_path")" ] && rm "$file_path" "$ref"
}

note::main() {
	#handles only one file at a time, unless they're already created, then it kind of works for two
	if [ $# -gt 0 ]; then
		local raw_input="$@"
		local file_path="$(echo "${raw_input%.*}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
		if [[ -f "$file_path.md" ]]; then
			note::access "$file_path"
		else
			local title=$(echo "$(basename "${raw_input%.*}")")
			note::create "$title" "$file_path"
		fi
	fi
}
