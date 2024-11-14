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
    inputs.nixvim.homeManagerModule.nixvim
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins.lualine.enable = true;
  };
}
