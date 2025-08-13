{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ gnome-tweaks ];

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

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
