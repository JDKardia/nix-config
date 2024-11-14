{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs._1password-cli.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["kardia"];
  };
}
