{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
  ];

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  security.polkit.enable = true;

  home-manager.users.kardia = {

    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4"; # win/cmd
        # Use kitty as default terminal
        terminal = "ghostty";
        startup = [
          { command = "dropbox"; }
          { command = "syncthingtray"; }
          { command = "1password"; }
        ];
      };
    };

  };

}
