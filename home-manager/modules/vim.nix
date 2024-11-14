{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  helpers = config.lib.nixvim;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    vimAlias = true;
    viAlias = true;

    colorschemes.gruvbox.enable = true;
    plugins.lualine.enable = true;
  };
}
