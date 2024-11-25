# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  home-manager.users.kardia = {
    inputs,
    lib,
    pkgs,
    my,
    ...
  }: let
    onePassPath = "~/.1password/agent.sock";
    np = inputs.nixpkgs.lib;
  in {
    imports = np.attrValues (my.lib.modulesIn ./submodules);

    home = {
      username = "kardia";
      homeDirectory = "/home/kardia";
      packages = with pkgs; [
        vscode
        nil
        alejandra
        firefox-beta
        statix
        deadnix
        chromium
        reaper
        audacity
        yt-dlp
        slack
        discord
        mpv
        mpvScripts.thumbfast
        mpvScripts.mpv-webm
        #contour
        alacritty
        zellij
        # keyd
        gnomeExtensions.appindicator
        nerdfonts
      ];
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
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
        ];
      };
    };

    # prevent services requiring a tray from crashing
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  };
}
