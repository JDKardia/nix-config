{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Kardia";
    userEmail = "joe@kardia.codes";
  };
  programs.jujutsu = {
    enable = true;
  };
}
