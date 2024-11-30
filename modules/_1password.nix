{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Enable common container config files in /etc/containers
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["kardia"];
    };
  };
}
