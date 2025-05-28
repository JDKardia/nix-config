{ pkgs, niri, ... }:
{
  environment.systemPackages = with pkgs; [

    xdg-desktop-portal-gtk # implements most of the basic functionality, this is the "default fallback portal".
    xdg-desktop-portal-gnome # required for screencasting support.
    gnome-keyring # implements the Secret portal, required for certain apps to work.

    mako # notification system developed by swaywm maintainer
    fuzzel # application picker
    alacritty # default term
  ];

  programs.niri = {
    enable = true;
    # package = pkgs.niri-stable;
  };

  home-manager.users.kardia = {
    programs.niri = {
      # enable = true;
      settings = {
        input.keyboard.xkb.options = "caps:escape";
      };
    };
  };

}
