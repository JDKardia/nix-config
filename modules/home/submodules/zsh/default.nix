{
  lib,
  config,
  nixpkgs,
  pkgs,
  ...
}: let
  np = nixpkgs.lib;
  plugins = with pkgs; [
    zsh-z
    zsh-powerlevel10k
    zsh-zhooks
    zsh-you-should-use
    zsh-nix-shell
    zsh-fzf-history-search
    jq-zsh-plugin
    zsh-defer
  ];
  pkg_to_zsh_plugin = p: {
    name = p.pname;
    inherit (p) src;
  };
in {
  home = {
    packages = plugins;
    sessionPath = [
      "\$HOME/bin"
      "\$HOME/.local/bin"
    ];
    shellAliases = {
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
    file = lib.mapAttrs' (name: _: {
      name = ".local/bin/${name}";
      value = {
        source = ./scripts + "/${name}";
        executable = true;
      };
    }) (builtins.readDir ./scripts);
  };

  programs = {
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
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
      plugins = builtins.map pkg_to_zsh_plugin plugins;
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

    zellij.enableZshIntegration = true;
    fzf.enableZshIntegration = true;
  };

  xdg.configFile."zsh/p10k.zsh".source = ./p10k.zsh;

  # TODO fix mutable symlinks with ncfavier helper function
}
