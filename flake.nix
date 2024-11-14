{
  description = "kardia's nix config";
  inputs = {
    # Nixpkgs: nixos-unstable head as of 2024-11-13
    nixpkgs.url = "github:nixos/nixpkgs/76612b17c0ce71689921ca12d9ffdc9c23ce40b2";
    unstable.follows = "nixpkgs";
    # Disko: for disk setup
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # better flake utils
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    utils.inputs.nixpkgs.follows = "nixpkgs";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "utils";

    hardware.url = "github:NixOS/nixos-hardware/master";
    #programs-db.url = "https://channels.nixos.org/nixos-22.05/nixexprs.tar.xz";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      naga = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
    };
  };
}
