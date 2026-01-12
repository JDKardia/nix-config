{ username, ... }:
{

  home-manager.users.${username} =
    { config, ... }:
    let
      homeDir = config.home.homeDirectory;
    in
    {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "Kardia";
            email = "joe@voiceofunreason.com";
          };
          color = {
            pager = true;
            branch = "auto";
            decorate = "auto";
            diff = "auto";
            grep = "auto";
            interactive = "auto";
            log = "auto";
            showbranch = "auto";
            status = "auto";
            ui = "auto";
          };
          rebase = {
            update-refs = true;
          };

          fetch = {
            recurseSubmodules = true;
            prune = true;
          };

          grep = {
            extendedRegexp = true;
          };

          diff = {
            colorMoved = "default";
            tool = "vimdiff";
            algorithm = "histogram";
          };

          difftool = {
            prompt = false;
            keepBackup = false;
          };

          mergetool.keepBackup = false;

          merge = {
            conflictstyle = "zdiff3";
            verbosity = 3;
            tool = "vimdiff";
          };

          push = {
            default = "current";
            autoSetupRemote = true;
          };

          pull.ff = "only";

          init.defaultBranch = "master";

          alias = {
            #{{{
            repo-root = "rev-parse --show-toplevel";
            print-head = ''!cat "$(git repo-root)/.git/refs/remotes/origin/HEAD" | cut -d'/' -f4'';
            fetch-remote = ''
              !fr() { \
                                            git fetch origin +$1:$1; \
                                          }; \
                                          fr'';
            remote-fetch = ''
              !rf() { \
                                            git config --add remote.origin.fetch +refs/heads/$1:refs/remotes/origin/$1; \
                                            git fetch origin +$1:refs/remotes/origin/$1; \
                                          }; \
                                          rf'';
            remote-purge = ''
              !rp() { \
                                            git config --unset remote.origin.fetch ".*$1.*"; \
                                            git update-ref -d refs/remotes/origin/$1; \
                                          }; \
                                          rp'';
            super-prune = ''
              !sp() { local _head=$(git print-head); \
                                          local _failed="$(mktemp)"; \
                                          git branch --merged "$_head"" | grep -v '^[ *]*'"$_head"'$' | xargs -n1 git branch -d 2>"$_failed"; \
                                          echo "the following branches were not pruned:"; \
                                          cat "$_failed" | grep 'error:' | sed "s/.* '/  /g;s/' .*//g;"; \
                                         }; \
                                         sp 2>/dev/null'';

            #############
            c = "commit";
            ca = "commit -all";
            cm = "commit --message";
            cam = "commit --all --message";
            cem = "commit --allow-empty -m";
            caam = "commit --all --amend --no-edit";
            #############
            nb = "checkout -b";
            nbm = ''
              !nbm(){ \
                                   local _head=$(git print-head); \
                                   git checkout "$_head" && git pull && git checkout -b "$1"; \
                                 }; \
                                 nbm'';
            opr = ''
              !opr(){ \
                                   git fetch-remote "$1" && git checkout "$1"; \
                                 }; \
                                 opr'';
            #############
            diff-word = "diff --word-diff";
            #############
            l = "log --color --pretty='format:%h %<(14 rtrunc)%an %s'";
            ll = "log --oneline";
            lg = "log --oneline --graph --decorate";
            #############
            behind = "!git rev-list --left-only --count $(git bu)...HEAD";
            ahead = "!git rev-list --right-only --count $(git bu)...HEAD";
            #}}}

          };
        };
        includes = [
          {
            condition = "gitdir:${homeDir}/MyCode/**";
            path = "${homeDir}/MyCode/.gitconfig";
          }
          {
            condition = "gitdir:${homeDir}/OthersCode/**";
            path = "${homeDir}/OthersCode/.gitconfig";
          }
          {
            condition = "gitdir:${homeDir}/code/**";
            path = "${homeDir}/code/.gitconfig";
          }
        ];
      };
      programs.jujutsu = {
        enable = true;
      };
    };
}
