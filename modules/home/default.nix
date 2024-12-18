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
            alacritty
            audacity
            chromium
            discord
            firefox-beta
            gimp
            gnomeExtensions.appindicator
            mpv
            mpvScripts.mpv-webm
            mpvScripts.thumbfast
            nil
            obs-studio
            reaper
            slack
            vlc
            vscode
            yt-dlp
            zellij

            nerd-fonts._0xproto
            nerd-fonts._3270
            nerd-fonts.agave
            nerd-fonts.anonymice
            nerd-fonts.arimo
            nerd-fonts.aurulent-sans-mono
            nerd-fonts.bigblue-terminal
            nerd-fonts.bitstream-vera-sans-mono
            nerd-fonts.blex-mono
            nerd-fonts.caskaydia-cove
            nerd-fonts.caskaydia-mono
            nerd-fonts.code-new-roman
            nerd-fonts.comic-shanns-mono
            nerd-fonts.commit-mono
            nerd-fonts.cousine
            nerd-fonts.d2coding
            nerd-fonts.daddy-time-mono
            nerd-fonts.departure-mono
            nerd-fonts.dejavu-sans-mono
            nerd-fonts.droid-sans-mono
            nerd-fonts.envy-code-r
            nerd-fonts.fantasque-sans-mono
            nerd-fonts.fira-code
            nerd-fonts.fira-mono
            nerd-fonts.geist-mono
            nerd-fonts.go-mono
            nerd-fonts.gohufont
            nerd-fonts.hack
            nerd-fonts.hasklug
            nerd-fonts.heavy-data
            nerd-fonts.hurmit
            nerd-fonts.im-writing
            nerd-fonts.inconsolata
            nerd-fonts.inconsolata-go
            nerd-fonts.inconsolata-lgc
            nerd-fonts.intone-mono
            nerd-fonts.iosevka
            nerd-fonts.iosevka-term
            nerd-fonts.iosevka-term-slab
            nerd-fonts.jetbrains-mono
            nerd-fonts.lekton
            nerd-fonts.liberation
            nerd-fonts.lilex
            nerd-fonts.martian-mono
            nerd-fonts.meslo-lg
            nerd-fonts.monaspace
            nerd-fonts.monofur
            nerd-fonts.monoid
            nerd-fonts.mononoki
            nerd-fonts.mplus
            nerd-fonts.noto
            nerd-fonts.open-dyslexic
            nerd-fonts.overpass
            nerd-fonts.profont
            nerd-fonts.proggy-clean-tt
            nerd-fonts.recursive-mono
            nerd-fonts.roboto-mono
            nerd-fonts.shure-tech-mono
            nerd-fonts.sauce-code-pro
            nerd-fonts.space-mono
            nerd-fonts.symbols-only
            nerd-fonts.terminess-ttf
            nerd-fonts.tinos
            nerd-fonts.ubuntu
            nerd-fonts.ubuntu-mono
            nerd-fonts.ubuntu-sans
            nerd-fonts.victor-mono
            nerd-fonts.zed-mono

          ]
          ++ (with pkgs.nerd-fonts; [

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
