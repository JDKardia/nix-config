{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.syncthing.enable = true;
  services.syncthing.tray.enable = true;
}
