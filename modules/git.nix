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
        userName = "Kardia";
        userEmail = "joe@voiceofunreason.com";
        extraConfig = {
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
        };

        aliases = {
          #{{{
          fetch-remote = ''"!fr() { git fetch origin +$1:$1; }; fr"'';
          remote-fetch = ''"!rf() { git config --add remote.origin.fetch +refs/heads/$1:refs/remotes/origin/$1; git fetch origin +$1:refs/remotes/origin/$1; }; rf"'';
          remote-purge = ''"!rp() { git config --unset remote.origin.fetch \".*$1.*\"; git update-ref -d refs/remotes/origin/$1; }; rp"'';
          super-prune = ''"!sp() { local failed=\"$(mktemp)\"; git branch --merged master | grep -v '^[ *]*master$' | xargs -n1 git branch -d 2>\"''${failed}\"; echo \"the following branches were not pruned:\"; cat \"''${failed}\" | grep 'error:' | sed \"s/.* '/  /g;s/' .*//g;\";  }; sp 2>/dev/null"'';

          #############
          s = "status";
          sb = "status -s -b";
          #############
          c = "commit";
          ca = "commit -all";
          cm = "commit --message";
          cam = "commit --all --message";
          cem = "commit --allow-empty -m";
          caam = "commit --all --amend --no-edit";
          #############
          o = "checkout";
          om = "checkout master";
          nb = "checkout -b";
          nbm = ''"!nbm(){ git checkout master && git pull && git checkout -b \"$1\"; }; nbm"'';
          opr = ''"!opr(){ git fetch-remote \"$1\" && git checkout \"$1\"; }; opr"'';
          #############
          pu = "push -u";
          #############
          d = "diff";
          dw = "diff --word-diff";
          dp = "diff --patience";
          dc = "diff --cached";
          dk = "diff --check";
          dck = "diff --cached --check";
          dt = "difftool";
          dct = "difftool --cached";
          #############
          r = "reset";
          rh = "reset HEAD";
          rb = "reset HEAD~";
          #############
          l = "log --color --pretty='format:%h %<(14 rtrunc)%an %s'";
          ll = "log --oneline";
          lg = "log --oneline --graph --decorate";
          #############
          a = "add";
          aa = "add --all";
          ai = "add -i";
          #############
          f = "fetch";
          fo = "fetch origin";
          fu = "fetch upstream";
          #############
          fp = "format-patch";
          #############
          fk = "fsck";
          #############
          g = "grep -p";
          #############
          b = "branch";
          ba = "branch -a";
          bd = "branch -d";
          bdd = "branch -D";
          br = "branch -r";
          bc = "rev-parse --abbrev-ref HEAD";
          bu = ''"!git rev-parse --abbrev-ref --symbolic-full-name "@{u}"'';
          #############
          ls = "ls-files";
          lsf = "!git ls-files | grep -i";
          #############
          m = "merge";
          ma = "merge --abort";
          mc = "merge --continue";
          ms = "merge --skip";
          #############
          sa = "stash apply";
          sc = "stash clear";
          sd = "stash drop";
          sl = "stash list";
          sp = "stash pop";
          ss = "stash --staged";
          sw = "stash show";
          st = "!git stash list | wc -l 2>/dev/null | grep -oEi '[0-9][0-9]*'";
          #############
          t = "tag";
          td = "tag -d";
          #############
          w = "worktree";
          wa = "worktree add";
          wl = "worktree list";
          #############
          behind = "!git rev-list --left-only --count $(git bu)...HEAD";
          ahead = "!git rev-list --right-only --count $(git bu)...HEAD";
          #}}}

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
