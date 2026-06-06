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
  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
    lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0"
      [
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-plugins-ugly
        pkgs.gst_all_1.gst-plugins-libav
      ];

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
