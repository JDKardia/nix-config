{ pkgs, ... }:
{
  # nixpkgs.config.pulseaudio=true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin # archive management context menu options
    thunar-dropbox-plugin # dropbox context-menu options
    thunar-media-tags-plugin
    thunar-volman
  ];
  services.xserver = {
    enable = true;
    desktopManager = {
      xfce.enable = true;
      xterm.enable = true;
    };

    # resolution and graphics setup
    videoDrivers = [ "nvidia" ];
    resolutions = [
      {
        x = 2560;
        y = 1440;
      }
    ];
  };
}
