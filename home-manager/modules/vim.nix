{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins.lualine.enable = true;
  };
}
