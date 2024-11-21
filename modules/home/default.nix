# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  home-manager.users.kardia = {
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    my,
    this,
    ...
  }: let
    onePassPath = "~/.1password/agent.sock";
  in {
    imports = inputs.nixpkgs.lib.attrValues (my.lib.modulesIn ./modules);
    # imports = [
    #
    #   ./modules/vim.nix
    #   ./modules/dropbox.nix
    #   ./modules/git.nix
    #   ./modules/syncthing.nix
    #   ./modules/zsh
    # ];
    home = {
      username = "kardia";
      homeDirectory = "/home/kardia";
    };

    # Add stuff for your user as you see fit:
    home.packages = with pkgs; [
      vscode
      nil
      alejandra
      firefox-beta
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

    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    # Enable home-manager and git
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host *
            IdentityAgent ${onePassPath}
      '';
    };
    programs.home-manager.enable = true;

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
    home.stateVersion = "24.05";
  };
}
