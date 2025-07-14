export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
[ -z "''${MANPATH-}" ] || export MANPATH=":''${MANPATH#:}";
export INFOPATH="/opt/homebrew/share/info:''${INFOPATH:-}";
