{
  inputs,
  outputs,
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zsh-z
    zsh-powerlevel10k
  ];
  home.sessionPath = [
    "\$HOME/.local/bin"
  ];
  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };
  home.shellAliases = {
    # Default Arg Aliases
    rg = "rg --smart-case";
    cp = "cp -i"; # Confirm before overwriting something
    rm = "rm -i";
    mv = "mv -i";
    df = "df -h"; # Human-readable sizes
    du = "du -h"; # Human-readable sizes
    fd = "fd --hidden";
    free = "free -m"; # Show sizes in MB
    ls = "ls --color=auto";
    e = "exa";
    grep = "grep --color";

    # Make My Own Command Aliases
    n = "note";
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";
    tolower = "tr '[:upper:]' '[:lower:]'";
    toupper = "tr '[:lower:]' '[:upper:]'";
    git-root = "cd $(git rev-parse --show-toplevel)";

    # Shortcut Aliases
    g = "git";
    gs = "git status -sb";
    k = "kubectl";
    l = "ls -lFh"; #size,show type,human readable
    la = "ls -lAFh"; #long list,show almost all,show type,human readable
    lr = "ls -tRFh"; #sorted by date,recursive,show type,human readable
    lt = "ls -ltFh"; #long list,sorted by date,show type,human readable
    ll = "ls -l"; #long list
    lld = "ls -ld -- */"; # long list only dir
    ld = "ls -d -- */"; # only dir
    lf = "ls -pA  | grep -v '\"/\"'";
    llf = "ls -lpA  | grep -v '\"/\"'";

    gr = "git-root";
    gitroot = "git-root";
  };
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";
    autosuggestion.enable = true;

    enableCompletion = true;

    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = ["main" "brackets" "pattern" "root" "line"];

    historySubstringSearch.enable = true;
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      save = 1000000;
      extended = true;
      share = true;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
    };
    initExtraBeforeCompInit = ''
      ## setup tab completion
        zstyle ':completion:*' matcher-list ''' 'm:{a-z}={A-Z}' 'm:{a-zA-Z-_}={A-Za-z-_}' 'r:|=*' 'l:|=* r:|=*'
        zstyle ':completion:*' rehash true # automatically find new executables in path

      ## Speed up completions
        zstyle ':completion:*' accept-exact '*(N)'
        # Don't consider certain characters part of the word
        zstyle ':completion:*' use-cache on zstyle ':completion:*' cache-path ~/.zsh/cache WORDCHARS=''${WORDCHARS//\/[&.;]/}

      ## set up colors
        #zstyle ":completion:*" list-colors “''${(s.:.)LS_COLORS}”

      ## zsh-z menus
          zstyle ':completion:*' menu selectzs
    '';
    initExtraFirst = ''
      export TIME_STYLE="long-iso"
      export CLICOLOR=YES
    '';
    initExtra = ''
      source "${config.xdg.configHome}/zsh/p10k.zsh"
    '';
  };

  xdg.configFile."zsh/p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink ./p10k.zsh;

  home.file.".local/bin/c".source = config.lib.file.mkOutOfStoreSymlink .scripts/c;
  home.file.".local/bin/c".executable = true;
  home.file.".local/bin/isotime".source = config.lib.file.mkOutOfStoreSymlink .scripts/isotime;
  home.file.".local/bin/isotime".executable = true;

  programs.zellij.enableZshIntegration = true;
  programs.fzf.enableZshIntegration = true;
}
