{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ gnome-tweaks ];

  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

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
