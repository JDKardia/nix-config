{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["kardia"];
  };
}
