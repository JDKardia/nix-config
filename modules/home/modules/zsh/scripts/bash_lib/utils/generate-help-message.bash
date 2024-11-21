#!/usr/bin/env bash

# Help message generation
_gen-help-message() { #_() generates a help message by parsing the script comments
  #_<< USAGE: _gen-help-message $file_path $start_pattern $end_pattern $is_for_Dev
  #{{{
  #    dev guidance {{{
  #_<>
  #_## NOTES ON THE DSL FOR GENERATING HELP MESSAGES
  #_##   ripgreps across this file for all text between start and end pattern,
  #_##   matches on specific types of comments, then munges each line based on
  #_##   the type of comment matched.
  #_<>
  #_##   by default, _gen-help-message will only emit comments for the normal help message.
  #_##   however, if $is_for_dev == 1 then only dev help comments will be emitted.
  #_<>
  #_##   all comment markers must be followed with atleast a single character of whitespace,
  #_##   as all but one regex uses a trailing '\s' token to prevent detecting themselves.
  #_<>
  #_## NORMAL HELP COMMENTS
  #_##   marker: '#()'
  #_##   name: function documenting
  #_##   behavior: removes '() {' from function definition and replaces comment marker with arrow
  #_<>
  #_##   marker: '###'
  #_##   name: depth preserving
  #_##   behavior: replaces comment marker and all to its left with whitespace
  #_<>
  #_##   marker: '#<<'
  #_##   name: depth omitting
  #_##   behavior: removes comment marker and all to its left with whitespace
  #_<>
  #_##   marker: '#<>'
  #_##   name: break
  #_##   behavior: removes entire line, acting as a line break
  #_<>
  #_## DEV HELP COMMENTS
  #_##   The same as normal help comments, except there is an additional '_' inserted
  #_##   into the beginning of the comment marker:
  #_##   Normal  | Dev
  #_##   -----------------
  #_##   '#()' | '#_()'
  #_##   '###' | '#_##'
  #_##   '#<<' | '#_<<'
  #_##   '#<>' | '#_<>'
  #_<>
  #_## INDENT MODIFIERS
  #_##   To facilitate manual indent control, a comment may terminate with up to 2
  #_##   indent modifiers, either positive ('>>') or negative ('<<'), to indent
  #_##   the generated line out or in by 2 spaces respectively
  #_<>
  # }}}

  # local constants {{{
  local func_doc_pat='#\(\)\s'
  local depth_pres_pat='###\s'
  local depth_omit_pat='#<<\s'
  local break_pat='^\s*#<>$'
  local dev_func_doc_pat='#_\(\)\s'
  local dev_depth_pres_pat='#_##\s'
  local dev_depth_omit_pat='#_<<\s'
  local dev_break_pat='^\s*#_<>$'
  # }}}
  # local helper functions {{{
  process-function-documenting() { sed 's/() \?{//g; s/#()\(\s\)/->\1/g;'; }
  process-dev-function-documenting() { sed 's/() \?{//g; s/#_()\(\s\)/->\1/g;'; }

  process-depth-preserving() { awk -F'###[[:space:]]' '{ if ($2){ gsub(/./," ",$1); print $1 $2} else { print $1 } }'; }
  process-dev-depth-preserving() { awk -F'#_##[[:space:]]' '{ if ($2){ gsub(/./," ",$1); print $1 $2} else { print $1 } }'; }

  process-depth-omitting() { sed 's/.*#<<\s//g'; }
  process-dev-depth-omitting() { sed 's/.*#_<<\s//g'; }

  process-break() { sed 's/^\s*#<>$//g'; }
  process-dev-break() { sed 's/^\s*#_<>$//g'; }

  process-positive-indent() { sed 's/^\(.*\)>>$/  \1/g; s/^\(.*\)>>$/  \1/g;'; }
  process-negative-indent() { sed 's/^  \(.*\)<<$/\1/g; s/^  \(.*\)<<$/\1/g;'; }
  # }}}

  # Logic {{{
  local file_path="$1"
  local start_pattern="${2:-}"
  local end_pattern="${3:-}"
  local is_for_dev="${4:-0}"

  local search_pattern
  ((is_for_dev == 1)) &&
    search_pattern="$dev_func_doc_pat|$dev_depth_pres_pat|$dev_depth_omit_pat|$dev_break_pat" ||
    search_pattern="$func_doc_pat|$depth_pres_pat|$depth_omit_pat|$break_pat"

  # retrieve block to emit help for
  commented_block="$(rg --multiline --multiline-dotall "$start_pattern.*$end_pattern" "$file_path")"

  # filter block down to lines with help comment markers
  filtered_block="$(echo "$commented_block" | rg "$search_pattern")"
  # }}}

  # Emitting the help message {{{
  echo "$filtered_block" |
    process-function-documenting |
    process-dev-function-documenting |
    process-depth-preserving |
    process-dev-depth-preserving |
    process-depth-omitting |
    process-dev-depth-omitting |
    process-break |
    process-dev-break |
    process-positive-indent |
    process-negative-indent
  # }}}
  # }}}
}
