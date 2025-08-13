# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  home-manager.users.kardia =
    {
      inputs,
      lib,
      pkgs,
      my,
      config,
      ...
    }:
    let
      onePassPath = "~/.1password/agent.sock";
      np = inputs.nixpkgs.lib;
    in
    {
      imports = np.attrValues (my.lib.modulesIn ./submodules);

      home = {
        username = "kardia";
        homeDirectory = "/home/kardia";
        sessionVariables = {
          SYSTEM_FLAKE = "${config.xdg.configHome}/nix";
        };
        packages =
          with pkgs;
          [
            # keyd
            #contour
            gthumb
            zoom-us
            alacritty
            audacity
            chromium
            discord
            firefox-beta
            gimp
            gnomeExtensions.appindicator
            mpv
            obsidian
            mpvScripts.mpv-webm
            mpvScripts.thumbfast
            nil
            obs-studio
            reaper
            slack
            vlc
            vscode
            yt-dlp
            yubikey-manager
            yubioath-flutter
            yubikey-personalization
            zellij
            lutris
            syncthingtray
          ]
          ++ (with pkgs.nerd-fonts; [
            _0xproto
            _3270
            agave
            anonymice
            arimo
            aurulent-sans-mono
            bigblue-terminal
            bitstream-vera-sans-mono
            blex-mono
            caskaydia-cove
            caskaydia-mono
            code-new-roman
            comic-shanns-mono
            commit-mono
            cousine
            d2coding
            daddy-time-mono
            departure-mono
            dejavu-sans-mono
            droid-sans-mono
            envy-code-r
            fantasque-sans-mono
            fira-code
            fira-mono
            geist-mono
            go-mono
            gohufont
            hack
            hasklug
            heavy-data
            hurmit
            im-writing
            inconsolata
            inconsolata-go
            inconsolata-lgc
            intone-mono
            iosevka
            iosevka-term
            iosevka-term-slab
            jetbrains-mono
            lekton
            liberation
            lilex
            martian-mono
            meslo-lg
            monaspace
            monofur
            monoid
            mononoki
            noto
            open-dyslexic
            overpass
            profont
            proggy-clean-tt
            recursive-mono
            roboto-mono
            shure-tech-mono
            sauce-code-pro
            space-mono
            symbols-only
            terminess-ttf
            tinos
            ubuntu
            ubuntu-mono
            ubuntu-sans
            victor-mono
            zed-mono

          ]);
        stateVersion = "24.05";
      };

      programs = {
        home-manager.enable = true;
        nix-index = {
          enable = true;
          enableZshIntegration = true;
        };
        # Enable home-manager and git
        ssh = {
          enable = true;
          extraConfig = ''
            Host *
                IdentityAgent ${onePassPath}
          '';
        };
      };
      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      dconf.settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
        };
      };

      # prevent services requiring a tray from crashing
      systemd.user.targets.tray = {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session-pre.target" ];
        };
      };

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    };
}
