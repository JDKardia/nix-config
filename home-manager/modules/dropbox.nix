{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.dropbox = {
    enable = true;
    path = "${config.home.homeDirectory}/Dropbox";
  };
}
