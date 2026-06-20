_: {
  services.nordvpn = {
    enable = true;
    users = [ "kardia" ]; # added to the `nordvpn` group
    gui.enable = true; # optional desktop GUI
  };
  # imports = [
  #   inputs.nur.modules.nixos.default
  #   inputs.nur.legacyPackages.x86_64-linux.repos.wingej0.modules.nordvpn
  # ];
  #
  # # Install NordVPN
  # nixpkgs.overlays = [
  #   (_final: _prev: {
  #     inherit (pkgs.nur.repos.wingej0) nordvpn;
  #   })
  # ];
  #
  # # Enable the service
  # services.nordvpn.enable = true;
  #
  # users.users.kardia = {
  #   extraGroups = [ "nordvpn" ];
  # };
}
