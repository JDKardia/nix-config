{ username, ... }:
{
  environment.variables.EDITOR = "nvim";
  home-manager.users.${username} =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      homeDir = config.home.homeDirectory;
      plugins = with pkgs; [
        zsh-z
        zsh-powerlevel10k
        zsh-zhooks
        zsh-you-should-use
        zsh-nix-shell
        zsh-fzf-history-search
        zsh-history-substring-search
        jq-zsh-plugin
        zsh-defer
        zsh-vi-mode
      ];
      pkg_to_zsh_plugin = p: {
        name = p.pname;
        inherit (p) src;
        ${
          # null keys are not set, allowing conditional tweaks
          if p.pname == "powerlevel10k" then "file" else null
        } =
          "powerlevel10k.zsh-theme";
      };
    in
    {
      home = {
        packages = plugins;
        sessionPath = [
          "\$HOME/.config/nix/modules/zsh/python_scripts"
          "\$HOME/.config/nix/modules/zsh/shell_scripts"
        ];
        # #TODO; make this work
        # sessionVariables={
        #
        # };
        shellAliases = {
          # Default Arg Aliases
          rg = "rg --smart-case";
          cp = "cp -i"; # Confirm before overwriting something
          rm = "rm -i";
          mv = "mv -i";
          df = "df -h"; # Human-readable sizes
          du = "du -h"; # Human-readable sizes

          free = "free -m"; # Show sizes in MB
          ls = "ls --color=auto";
          grep = "grep --color";

          # Make My Own Command Aliases
          # pbcopy = "xclip -selection clipboard";
          # pbpaste = "xclip -selection clipboard -o";
          tolower = "tr '[:upper:]' '[:lower:]'";
          toupper = "tr '[:lower:]' '[:upper:]'";
          git-root = "cd $(git rev-parse --show-toplevel)";

          # Shortcut Aliases
          gs = "git status -sb";
          l = "ls -lFh"; # size,show type,human readable
          la = "ls -lAFh"; # long list,show almost all,show type,human readable
          lr = "ls -tRFh"; # sorted by date,recursive,show type,human readable
          lt = "ls -ltFh"; # long list,sorted by date,show type,human readable
          ll = "ls -l"; # long list
          lld = "ls -ld -- */"; # long list only dir
          ld = "ls -d -- */"; # only dir
          lf = "ls -pA  | grep -v '\"/\"'";
          llf = "ls -lpA  | grep -v '\"/\"'";
          gp = "gtrash put"; # gtrash put
          gm = "gtrash put"; # gtrash move (easy to change to rm)
          tp = "gtrash put"; # trash put
          tm = "gtrash put"; # trash move (easy to change to rm)
          tt = "gtrash put"; # to trash
        };
        # file = lib.mapAttrs' (name: _: {
        #   name = ".local/bin/${name}";
        #   value = {
        #     source = ./scripts + "/${name}";
        #     executable = true;
        #   };
        # }) (builtins.readDir ./scripts);
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
          syntaxHighlighting.highlighters = [
            "main"
            "brackets"
            "pattern"
            "root"
            "line"
          ];

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
          initContent = lib.mkMerge [
            # first
            (lib.mkOrder 500 ''
              export TIME_STYLE="long-iso"
              export CLICOLOR=YES
            '')

            # before comp init
            (lib.mkOrder 550 ''
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

              ## completions
                # source "${homeDir}/${config.xdg.configFile."zsh/completions/_c".target}"
                # compdef _c c
              fpath+=($HOME/.config/nix/modules/home/submodules/zsh/completions)

            '')
            # extra after
            ''
              # source "${config.xdg.configHome}/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"
              source "${homeDir}/${config.xdg.configFile."zsh/p10k.zsh".target}"
              # up and down keys are already bound
              bindkey -M vicmd 'k' history-substring-search-up
              bindkey -M vicmd 'j' history-substring-search-down
              bindkey "$terminfo[kcuu1]" history-substring-search-up
              bindkey "$terminfo[kcud1]" history-substring-search-down
              bindkey '^[[A' history-substring-search-up
              bindkey '^[[B' history-substring-search-down

              HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
            ''
          ];
        };

        zellij.enableZshIntegration = true;
        fzf.enableZshIntegration = true;
      };

      xdg.configFile."zsh/p10k.zsh".source = ./p10k.zsh;
      xdg.configFile."zsh/completions/_c".source = ./completions/_c;

      # TODO fix mutable symlinks with ncfavier helper function
    };
}
