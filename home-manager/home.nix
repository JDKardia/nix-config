# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  onePassPath = "~/.1password/agent.sock";
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    inputs.nixvim.homeManagerModule
    ./modules/vim.nix
  ];

  home = {
    username = "kardia";
    homeDirectory = "/home/kardia";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    nil
    alejandra
    firefox-beta
    reaper
    audacity
    yt-dlp
    #  syncthing
    #  syncthingtray
    gnomeExtensions.appindicator
    discord
    mpv
    mpvScripts.thumbfast
    mpvScripts.mpv-webm
    #contour
    alacritty
    zellij
    # keyd
  ];

  xdg.desktopEntries = {
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
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
  programs.git = {
    enable = true;
    userName = "Kardia";
    userEmail = "joe@kardia.codes";
  };
  services.dropbox = {
    enable = true;
    path = "${config.home.homeDirectory}/Dropbox";
  };
  services.syncthing.enable = true;
  services.syncthing.tray.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
