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
    #   inputs.nixvim.homeManagerModule
    ./modules/vim.nix
    ./modules/dropbox.nix
    ./modules/git.nix
    ./modules/syncthing.nix
  ];

  home = {
    username = "kardia";
    homeDirectory = "/home/kardia";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
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
}
