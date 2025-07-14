# ## Keybindings section
bindkey -v
# 
#smash sudo to prepend or un-prepend line with sudo
for combo in \
  "sudo" "usdo" "dsuo" "sduo" "udso" "duso" "ousd" "uosd" \
  "soud" "osud" "usod" "suod" "sdou" "dsou" "osdu" "sodu" \
  "dosu" "odsu" "odus" "dous" "uods" "ouds" "duos" "udos"; do
  bindkey -M viins "$combo" sudo-command-line
  bindkey -M vicmd "$combo" sudo-command-line
done
# 
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
export KEYTIMEOUT=8

# # bind UP and DOWN arrow keys to history substring search
# #zmodload zsh/terminfo
# source "${config.xdg.configHome}/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"
#source "${homeDir}/${config.xdg.configFile."zsh/p10k.zsh".target}"
# up and down keys are already bound
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
