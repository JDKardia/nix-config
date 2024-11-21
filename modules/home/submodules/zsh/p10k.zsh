# Custom config for Powerlevel10k
#
# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

parse_git_branch() {
  # Show Git branch/tag, or name-rev if on detached head
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
}

parse_git_state() {
  # Show different symbols as appropriate for various Git repository states
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
  local NUM_AHEAD="$(git log --oneline @{u}.. 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
  local NUM_BEHIND="$(git log --oneline ..@{u} 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
  local GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
  if [[ -n $(git ls-files --other --exclude-standard 2>/dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
  if ! git diff --quiet 2>/dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
  if ! git diff --cached --quiet 2>/dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

git_prompt_string() {
  local git_where="$(parse_git_branch)"
  # If inside a Git repository, print its branch and state
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
  # If not inside the Git repo, print exit codes of last command (only if it failed)
  [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
}

RPROMPT='$(git_prompt_string)'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options. This allows you to apply configuration changes without
  # restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  autoload -Uz is-at-least && is-at-least 5.1 || return

  # The list of segments shown on the left.
	# I like to keep this as minimal as possible
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # ================[ Line #1 ]================
    dir            # current directory
		newline
    prompt_char    # prompt symbol
  )

  # The list of segments shown on the right. Fill it with less important segments.
  # Right prompt on the last prompt line (where you are typing your commands) gets
  # automatically hidden when the input line reaches it. Right prompt above the
  # last prompt line gets hidden if it would overlap with left prompt.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status                  # exit code of the last command
      command_execution_time  # duration of the last command
      background_jobs         # presence of background jobs
      context                 # user@host
      virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
      anaconda                # conda env
      kubecontext             # current kubernetes context (https://kubernetes.io/)
      gcloud                  # google cloud cli account and project (https://cloud.google.com/)
      #dir                     # current directory
      vcs                     # git status
      # battery               # internal battery
      time                    # current time
			newline
  )

  # Basic style options that define the overall prompt look.
	#
  # Defines character set used by powerlevel10k. It's best to let `p10k configure` set it for you.
  typeset -g POWERLEVEL9K_MODE=ascii
  # When set to `moderate`, some icons will have an extra space after them. This is meant to avoid
  # icon overlap when using non-monospace fonts. When set to `none`, spaces are not added.
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol

  # When set to true, icons appear before content on both sides of the prompt. When set
  # to false, icons go after content. If empty or not set, icons go before content in the left
  # prompt and after content in the right prompt.
  #
  # You can also override it for a specific segment:
  #
  #   POWERLEVEL9K_STATUS_ICON_BEFORE_CONTENT=false
  #
  # Or for a specific segment in specific state:
  #
  #   POWERLEVEL9K_DIR_NOT_WRITABLE_ICON_BEFORE_CONTENT=false
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true

  # Add an empty line before each prompt.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # Connect left prompt lines with these symbols.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  # Connect right prompt lines with these symbols.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=

  # The left end of left prompt.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  # The right end of right prompt.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  # Add an empty line before each prompt. If you set it to false, you might want to
  # set POWERLEVEL9K_SHOW_RULER to true below.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # Ruler, a.k.a. the horizontal line before each prompt. If you set it to true, you'll
  # probably want to set POWERLEVEL9K_PROMPT_ADD_NEWLINE to false above.
  typeset -g POWERLEVEL9K_SHOW_RULER=false
  typeset -g POWERLEVEL9K_RULER_CHAR='─'
  typeset -g POWERLEVEL9K_RULER_FOREGROUND=236

  # Filler between left and right prompt on the first prompt line. You can set it to '·' or '-'
  # to make it easier to see the alignment between left and right prompt and to separate prompt
  # from command output. It serves the same purpose as ruler (see above) without increasing
  # the number of prompt lines. You'll probably want to set POWERLEVEL9K_SHOW_RULER=false
  # if using this. You might also like POWERLEVEL9K_PROMPT_ADD_NEWLINE=false for more compact
  # prompt.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='-'
  if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
    # The color of the filler.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=238
    # Add a space between the end of left prompt and the filler.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '
    # Add a space between the filler and the start of right prompt.
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=' '
    # Start filler from the edge of the screen if there are no left segments on the first line.
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    # End filler on the edge of the screen if there are no right segments on the first line.
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
  fi


  # Disable segment icons by default.
  #
  # To set a specific icon for a segment (e.g., dir), define
  # POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='⭐'.
  #
  # To set a specific icon for a segment in a given state (e.g., dir in state NOT_WRITABLE),
  # define POWERLEVEL9K_DIR_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION='⭐'.
  #
  # To enable default segment icons for one segment (e.g., dir), define
  # POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'.
  #
  # To enable default icons for all segments, don't set POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION
  # or set it to '${P9K_VISUAL_IDENTIFIER}'.
  #
  # When a segment is displaying its default icon, in addition to being able to chage it with
  # VISUAL_IDENTIFIER_EXPANSION as described above, you can also change it with an override
  # such as POWERLEVEL9K_LOCK_ICON='⭐'. This will change the icon in every segment that uses
  # LOCK_ICON as default icon.
  #
  # Note: Many default icons cannot be displayed with system fonts. You'll need to install a
  # Powerline font to use them.
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=

  # This option doesn't make a difference unless you've enabled default icons for all or some
  # prompt segments (see POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION above). Default icons depend on
  # the value of POWERLEVEL9K_MODE. For example, LOCK_ICON can be printed as $'\uE0A2', $'\uE138'
  # or $'\uF023' depending on POWERLEVEL9K_MODE. The correct value of this parameter depends on
  # the provider of the font your terminal is using.
  #
  #   Font Provider                    | POWERLEVEL9K_MODE
  #   ---------------------------------+-------------------
  #   Powerline                        | powerline
  #   Font Awesome                     | awesome-fontconfig
  #   Adobe Source Code Pro            | awesome-fontconfig
  #   Source Code Pro                  | awesome-fontconfig
  #   Awesome-Terminal Fonts (regular) | awesome-fontconfig
  #   Awesome-Terminal Fonts (patched) | awesome-patched
  #   Nerd Fonts                       | nerdfont-complete
  #
  # Tip: Don't use default icons and forget about font configuration headaches.
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete

  # OS identifier color.
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=212
  # Want to display a different icon? Uncomment the next line and set the desired value.
  # typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=$'\uFB8A'

  ################################[ prompt_char: prompt symbol ]################################
  # Green prompt symbol if the last command succeeded.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=002
  # Red prompt symbol if the last command failed.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=001
  # Default prompt symbol.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='$'
  # Prompt symbol in command vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='N'
  # Prompt symbol in visual vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  # Prompt symbol in overwrite vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='^'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  # No line terminator if prompt_char is the last segment.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  # No line introducer if prompt_char is the first segment.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

  ##################################[ dir: current directory ]##################################
  # Enable special styling for non-writable directories. If set to false,
  # POWERLEVEL9K_DIR_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION defined below won't have effect.
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
  # Icon to display when the current directory isn't writable.
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION='%214F%B!w'
  # Default current directory color.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=003
  # If directory is too long, shorten some of its segments to the shortest possible unique
  # prefix. The shortened directory can be tab-completed to the original.
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  # Replace removed segment suffixes with this symbol.
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  # Color of the shortened directory segments.
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=006
  # Color of the anchor directory segments. Anchor segments are never shortened. The first
  # segment is always an anchor.
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=011
  # Display anchor directory segments in bold.
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  # Don't shorten directories that contain files matching this pattern. They are anchors.
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.shorten_folder_marker|.bzr|CVS|.git|.hg|.svn|.terraform|.citc)'
  # Don't shorten this many last directory segments. They are anchors.
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  # Shorten directory if it's longer than this even if there is space for it. The value can
  # be either absolute (e.g., '80') or a percentage of terminal width (e.g, '50%'). If empty,
  # directory will be shortened only when prompt doesn't fit.
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  # If set to true, embed a hyperlink into the directory. Useful for quickly
  # opening a directory in the file manager simply by clicking the link.
  # Can also be handy when the directory is shortened, as it allows you to see
  # the full directory that was used in previous commands.
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  # Don't show status on success.
  typeset -g POWERLEVEL9K_STATUS_OK=false
  # Error status color.
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=9
  # Don't show status unless the last command was terminated by a signal.
  # Show signals as "INT", "ABORT", "KILL", etc.
  typeset -g POWERLEVEL9K_STATUS_ERROR_CONTENT_EXPANSION='${${P9K_CONTENT#SIG}//[!A-Z]}'

  ###################[ command_execution_time: duration of the last command ]###################
  # Show duration of the last command if takes longer than this many seconds.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
  # Show this many fractional digits. Zero means round to seconds.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=3
  # Execution time color.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=221
  # Duration format: 1d 2h 3m 4s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  #######################[ background_jobs: presence of background jobs ]#######################
  # Don't show the number of background jobs.
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  # Icon to show when there are background jobs.
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='⇶'
  # Background jobs icon color.
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_COLOR=4

  ##################################[ context: user@hostname ]##################################
	#{{{
		# Context format: user@host.
		typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
		# Default context color.
		typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=244
		# Context color when running with privileges.
		typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=11
		# Don't show context unless running with privileges on in SSH.
		typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
		typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true

	# Python virtual environment color.
	typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=11
	# Show Python version next to the virtual environment name.
	typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
	# Separate environment name from Python version only with a space.
	typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

	# Anaconda environment color.
	typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=11
	# Show Python version next to the anaconda environment name.
	typeset -g POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION=true
	# Separate environment name from Python version only with a space.
	typeset -g POWERLEVEL9K_ANACONDA_{LEFT,RIGHT}_DELIMITER=

	# Pyenv color.
	typeset -g POWERLEVEL9K_PYENV_FOREGROUND=11
	# Don't show the current Python version if it's the same as global.
	typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false

	# Nodenv color.
	typeset -g POWERLEVEL9K_NODENV_FOREGROUND=3
	# Don't show node version if it's the same as global: $(nodenv version-name) == $(nodenv global).
	typeset -g POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW=false

	# Nvm color.
	typeset -g POWERLEVEL9K_NVM_FOREGROUND=3

	# Nodeenv color.
	typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=3

	# Node version color.
	typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=3
	# Show node version only when in a directory tree containing package.json.
	typeset -g P9K_NODE_VERSION_PROJECT_ONLY=true
  #}}}

 #############[ kubecontext: current kubernetes context (https://kubernetes.io/) ]#############
  # Show kubecontext only when the the command you are typing invokes one of these tools.
  # Tip: Remove the next line to always show kubecontext.
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern'

  # For example, given these settings:
  #
  #   typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
  #     '*prod*'  PROD
  #     '*test*'  TEST
  #     '*'       DEFAULT)
  #
  # You can define different colors, icons and content expansions for different classes:
  #
  #   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_FOREGROUND=3
  #   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
  typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
      # '*prod*'  PROD    # These values are examples that are unlikely
      # '*test*'  TEST    # to match your needs. Customize them as needed.
      '*'       DEFAULT)
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=012

  # If P9K_KUBECONTEXT_CLUSTER is "arn:aws:eks:us-east-1:123456789012:cluster/my-cluster-01":
  #
  #   - P9K_KUBECONTEXT_CLOUD_NAME=eks
  #   - P9K_KUBECONTEXT_CLOUD_ACCOUNT=123456789012
  #   - P9K_KUBECONTEXT_CLOUD_ZONE=us-east-1
  #   - P9K_KUBECONTEXT_CLOUD_CLUSTER=my-cluster-01
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
  # Show P9K_KUBECONTEXT_CLOUD_CLUSTER if it's not empty and fall back to P9K_KUBECONTEXT_NAME.
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
  # Append the current context's namespace if it's not "default".
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

  # Public IP color.
  typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=144

  # Show battery in red when it's below this level and not connected to power supply.
  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
  typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=1
  # Show battery in green when it's charging.
  typeset -g POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND=2
  # Show battery in yellow when not connected to power supply.
  typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=3
  # Battery pictograms going from low to high level of charge.
  typeset -g POWERLEVEL9K_BATTERY_STAGES='▁▂▃▄▅▆▇'
  # Display battery pictogram on black background.
  typeset -g POWERLEVEL9K_BATTERY_VISUAL_IDENTIFIER_EXPANSION='%0K${P9K_VISUAL_IDENTIFIER}%k'
  # Don't show battery when it's fully charged and connected to power supply.
  typeset -g POWERLEVEL9K_BATTERY_CHARGED_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
  # Don't show the remaining time to charge/discharge.
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false

  # Current time color.
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=015
  # Format for the current time: 09:51:02. See `man 3 strftime`.
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  # If set to true, time will update when you hit enter. This way prompts for the past
  # commands will contain the start times of their commands as opposed to the default
  # behavior where they contain the end times of their preceding commands.
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false


  ##########[ gcloud: google cloud account and project (https://cloud.google.com/) ]###########
  # Show gcloud only when the the command you are typing invokes one of these tools.
  # Tip: Remove the next line to always show gcloud.
  # typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|gsutil'
  # Google cloud color.
  typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=012

  # Google cloud format. Change the value of POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION and/or
  # POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION if the default is too verbose or not informative
  # enough. You can use the following parameters in the expansions. Each of them corresponds to the
  # output of `gcloud` tool.
#
  #   Parameter                | Source
  #   -------------------------|--------------------------------------------------------------------
  #   P9K_GCLOUD_CONFIGURATION | gcloud config configurations list --format='value(name)'
  #   P9K_GCLOUD_ACCOUNT       | gcloud config get-value account
  #   P9K_GCLOUD_PROJECT_ID    | gcloud config get-value project
  #   P9K_GCLOUD_PROJECT_NAME  | gcloud projects describe $P9K_GCLOUD_PROJECT_ID --format='value(name)'
  # You can customize the format, icon and colors of gcloud segment separately for states PARTIAL
  # and COMPLETE. You can also hide gcloud in state PARTIAL by setting
  # POWERLEVEL9K_GCLOUD_PARTIAL_VISUAL_IDENTIFIER_EXPANSION and
  # POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION to empty.
  typeset -g POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_ID//\%/%%}'
  typeset -g POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_NAME//\%/%%}'

  #####################################[ vcs: git status ]######################################
  # Branch icon. Set this parameter to '\uF126 ' for the popular Powerline branch icon.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=

  # Untracked files icon. It's really a question mark, your font isn't broken.
  # Change the value of this parameter to show a different icon.
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Formatter for Git status.
  #
  # Example output: master wip ⇣42⇡42 *42 merge ~42 +42 !42 ?42.
  #
  # You can edit the function to customize how Git status looks.
  #
  # VCS_STATUS_* parameters are set by gitstatus plugin. See reference:
  # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.
  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
      # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      # Styling for up-to-date Git status.
      local       meta='%f'   # default foreground
      local      clean='%2F'  # green foreground
      local   modified='%3F'  # yellow foreground
      local  untracked='%4F'  # blue foreground
      local conflicted='%1F'  # red foreground
    else
      # Styling for incomplete and stale Git status.
      local       meta='%f'  # default foreground
      local      clean='%f'  # default foreground
      local   modified='%f'  # default foreground
      local  untracked='%f'  # default foreground
      local conflicted='%f'  # default foreground
    fi

    local res

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      # If local branch name is at most 32 characters long, show it in full.
      # Otherwise show the first 12 … the last 12.
      # Tip: To always show local branch name in full without truncation, delete the next line.
      # (( $#branch > 32 )) && branch[13,-13]="…"  # <-- this line
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_TAG
          # Show tag only if not on a branch.
          # Tip: To always show tag, delete the next line.
          && -z $VCS_STATUS_LOCAL_BRANCH  # <-- this line
        ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      # If tag name is at most 32 characters long, show it in full.
      # Otherwise show the first 12 … the last 12.
      # Tip: To always show tag name in full without truncation, delete the next line.
      (( $#tag > 32 )) && tag[13,-13]="…"  # <-- this line
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    # Display the current Git commit if there is no branch and no tag.
    # Tip: To always display the current Git commit, delete the next line.
    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&  # <-- this line
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    # Show tracking branch name if it differs from local branch.
    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    # Display "wip" if the latest commit's summary contains "wip" or "WIP".
    if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
      res+=" ${modified}wip"
    fi

    # ⇣42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    # ⇠42 if behind the push remote.
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    # *42 if have stashes.
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    # 'merge' if the repo is in an unusual state.
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    # ~42 if have merge conflicts.
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    # +42 if have staged changes.
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    # !42 if have unstaged changes.
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    # ?42 if have untracked files. It's really a question mark, your font isn't broken.
    # See POWERLEVEL9K_VCS_UNTRACKED_ICON above if you want to use a different icon.
    # Remove the next line if you don't want to see untracked files at all.
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    # "─" if the number of unstaged files is unknown. This can happen due to
    # POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY (see below) being set to a non-negative number lower
    # than the number of files in the Git index, or due to bash.showDirtyState being set to false
    # in the repository config. The number of staged and untracked files may also be unknown
    # in this case.
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    typeset -g my_git_format=$res
  }

  functions -M my_git_formatter 2>/dev/null

  # Don't count the number of unstaged, untracked and conflicted files in Git repositories with
  # more than this many files in the index. Negative value means infinity.
  #
  # If you are working in Git repositories with tens of millions of files and seeing performance
  # sagging, try setting POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY to a number lower than the output
  # of `git ls-files | wc -l`. Alternatively, add `bash.showDirtyState = false` to the repository's
  # config: `git config bash.showDirtyState false`.
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  # Don't show Git status in prompt for repositories whose workdir matches this pattern.
  # For example, if set to '~', the Git repository at $HOME/.git will be ignored.
  # Multiple patterns can be combined with '|': '~(|/foo)|/bar/baz/*'.
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN=''

  # Disable the default Git status formatting.
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  # Install our own Git status formatter.
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  # Enable counters for staged, unstaged, etc.
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  # Icon color.
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=2
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=
  # Custom icon.
  # typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='⭐'
  # Custom prefix.
  # typeset -g POWERLEVEL9K_VCS_PREFIX='%fon '

  # Show status of repositories of these types. You can add svn and/or hg if you are
  # using them. If you do, your prompt may become slow even when your current directory
  # isn't in an svn or hg reposotiry.
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  # These settings are used for repositories other than Git or when gitstatusd fails and
  # Powerlevel10k has to fall back to using vcs_info.
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=2
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=3

}
  # Instant prompt mode.
  #
  #   - off:     Disable instant prompt. Choose this if you've tried instant prompt and found
  #              it incompatible with your zsh configuration files.
  #   - quiet:   Enable instant prompt and don't print warnings when detecting console output
  #              during zsh initialization. Choose this if you've read and understood
  #              https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt.
  #   - verbose: Enable instant prompt and print a warning when detecting console output during
  #              zsh initialization. Choose this if you've never tried instant prompt, haven't
  #              seen the warning, or if you are unsure what this all means.
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
  # For example, you can type POWERLEVEL9K_BACKGROUND=red and see your prompt turn red. Hot reload
  # can slow down prompt by 1-2 milliseconds, so it's better to keep it turned off unless you
  # really need it.
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true



(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
