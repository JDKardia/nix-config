{ username, ... }:
{
  environment.variables.EDITOR = "nvim";
  programs.zsh = {
    enable = true;
    # prevents uber slow /etc/zshrc
    enableGlobalCompInit = false;
    enableBashCompletion = false;
    promptInit = "";

  };
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
          "/opt/homebrew/bin"
          "/opt/homebrew/sbin"
          "\$HOME/.local/bin"
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
          completionInit = ''
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
            fpath+=($HOME/.config/zsh/completions)
            autoload -Uz compinit 
            if [[ -n ''${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
            	compinit;
            else
            	compinit -C;
            fi;
          '';

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
            size = 1000000;
            extended = true;
            share = true;
            expireDuplicatesFirst = true;
            ignoreSpace = true;
          };
          plugins = builtins.map pkg_to_zsh_plugin plugins;
          initContent =
            let
              # first
              early_preferences = lib.mkOrder 500 ''
                export TIME_STYLE="long-iso"
                export CLICOLOR=YES
              '';
              zsh_completion_fix = lib.mkOrder 501 ''
                fpath+=(
                  "${config.home.profileDirectory}"/share/zsh/site-functions 
                  "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions
                  "${config.home.profileDirectory}"/share/zsh/vendor-completions
                )
              '';
              # before compinit
              homebrew_integration = lib.mkOrder 551 (builtins.readFile ./homebrew.zsh);
              # extra after
              vim_controls = lib.mkOrder 1500 (builtins.readFile ./vim_controls.zsh);
              p10k_config = lib.mkOrder 1501 ''
                source "${homeDir}/${config.xdg.configFile."zsh/p10k.zsh".target}"
              '';
            in
            lib.mkMerge [
              # profile_start
              # profile_end
              early_preferences
              homebrew_integration
              vim_controls
              zsh_completion_fix
              p10k_config
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
