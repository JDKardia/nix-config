#!/usr/bin/env bash
# source our common context script
set -euo pipefail
IFS=$'\n\t'

# to dynamically change log level, export a new value of LOG_LEVEL
# to disable logging altogether, set LOG_LEVEL='nop'
# LOG_LEVEL is case insensitive (${LOG_LEVEL,,} expands LOG_LEVEL to all lowercase)
if [[ -z ${LOG_SOURCED+x} ]]; then
	# if unset, set the defaults
	[[ -z ${LOG_LEVEL+x} ]] && LOG_LEVEL="info" && export LOG_LEVEL
	[[ -z ${LOG_TO_JSON+x} ]] && LOG_TO_JSON="false" && export LOG_TO_JSON
	[[ -z ${LOG_FILE+x} ]] && LOG_FILE="/dev/stdout" && export LOG_FILE

	# define logging functions
	log::__log() {
		IFS=" $IFS"
		local severity formatting msg log_time outfile
		severity="$1"
		formatting="$2"
		shift 2
		msg="$*"
		log_time="$(date -Iseconds)"

		if [[ ${LOG_TO_JSON,,} == 'true' ]]; then
			# properly escape things for json
			msg=${msg//$'"'/'\"'}
			msg=${msg//$'\n'/'\n'}
			printf '{"timestamp": "%s", "severity": "%s", "log": "%s"}\n' "$log_time" "$severity" "$msg" >>"$LOG_FILE"
		else
			# handle default behavior of stdout/stderr routing if no user defined LOG_FILE
			[[ $LOG_FILE == '/dev/stdout' ]] &&
				[[ ${severity,,} =~ warn|error|fatal ]] &&
				outfile="/dev/stderr" || outfile="$LOG_FILE"
			printf "[ %s ][\e[%s %5s \e[%s] %s\n" "$log_time" "$formatting" "$severity" "m" "$msg" >>"$outfile"
		fi
		IFS="${IFS:1}"
	}

	log::debug() {
		# only log if LOG_LEVEL allows it
		[[ ${LOG_LEVEL,,} == 'nop' ]] && return 0
		[[ ${LOG_LEVEL,,} =~ debug ]] || return 0
		IFS=" $IFS"
		log::__log "DEBUG" "1;94;40;m" "$*"
		IFS="${IFS:1}"
	}
	log::info() {
		# only log if LOG_LEVEL allows it
		[[ ${LOG_LEVEL,,} == 'nop' ]] && return 0
		[[ ${LOG_LEVEL,,} =~ debug|info ]] || return 0
		IFS=" $IFS"
		log::__log "INFO" "1;92;40m" "$*"
		IFS="${IFS:1}"
	}
	log::warn() {
		# only log if LOG_LEVEL allows it
		[[ ${LOG_LEVEL,,} == 'nop' ]] && return 0
		[[ ${LOG_LEVEL,,} =~ debug|info|warn ]] || return 0
		IFS=" $IFS"
		log::__log "WARN" "1;33;40m" "$*"
		IFS="${IFS:1}"
	}
	log::error() {
		# only log if LOG_LEVEL allows it
		[[ ${LOG_LEVEL,,} == 'nop' ]] && return 0
		[[ ${LOG_LEVEL,,} =~ debug|info|warn|error ]] || return 0
		IFS=" $IFS"
		log::__log "ERROR" "1;91;40m" "$*"
		IFS="${IFS:1}"
	}
	log::fatal() {
		# only log if LOG_LEVEL allows it
		[[ ${LOG_LEVEL,,} == 'nop' ]] && return 0
		[[ ${LOG_LEVEL,,} =~ debug|info|warn|error|fatal ]] || return 0
		IFS=" $IFS"
		log::__log "FATAL" "1;99;41m" "$*"
		IFS="${IFS:1}"
		exit
	}

	# test specific log statements
	log::test::success() {
		IFS=" $IFS"
		log::__log "SUCCESS" '1;99;42m' "$*" >>/dev/stdout
		IFS="${IFS:1}"
	}
	log::test::failure() {
		IFS=" $IFS"
		log::__log "FAILURE" '1;99;41m' "$*" >>/dev/stderr
		IFS="${IFS:1}"
	}
	export -f log::__log \
		log::debug log::info log::warn log::error log::fatal \
		log::test::failure log::test::success
	# we've completed sourcing of these definitions, establish as such
	LOG_SOURCED="TRUE"
	export LOG_SOURCED
fi
