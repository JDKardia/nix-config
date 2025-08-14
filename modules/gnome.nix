{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    pkgs.gnomeExtensions.appindicator
  ];

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  services.xserver = {
    enable = true;

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
