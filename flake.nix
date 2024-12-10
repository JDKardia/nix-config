{
  description = "kardia's nix config";
  inputs = {
    # Nixpkgs: nixos-unstable head as of 2024-11-13
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.follows = "nixpkgs";

    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module?ref=main";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    programs-db.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:NixOS/nixos-hardware/master";

    # Disko: for disk setup
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # utils for this project
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      self,
      nixpkgs,
      lix-module,
      home-manager,
      treefmt-nix,

      ...
    }@inputs:
    let
      my = import ./lib nixpkgs.lib machines;
      machines = my.lib.exprsIn ./machines;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      treefmt = treefmt-nix.lib.evalModule pkgs (_pkgs: {
        projectRootFile = "flake.nix";
        programs = {
          mdsh.enable = true;
          nixfmt.enable = true;
          shellcheck.enable = true;
          taplo.enable = true;
          statix.enable = true;
          deadnix.enable = true;
          shfmt.enable = true;
        };
        settings.formatter = {
          shfmt = {
            includes = [
              "**/shell_scripts/*"
              "**/completions/*"
            ];
            options = [
              "--indent=2"
              "--keep-padding"
              "--case-indent"
              "--simplify"
              "--write"
            ];
          };
          shellcheck.includes = [ "**/shell_scripts/*" ];
          shellcheck.options = [ "--exclude=SC2001,SC2002,SC2015" ];
        };
      });
      inherit (self) outputs;
    in
    {
      formatter.${system} = treefmt.config.build.wrapper;

      nixosConfigurations = nixpkgs.lib.mapAttrs (
        host: hardware-config:
        let
          this = my.machines.${host};
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            lix-module.nixosModules.default
            hardware-config
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit
                    inputs
                    outputs
                    this
                    my
                    ;
                };
              };
            }
          ] ++ (nixpkgs.lib.attrValues (my.lib.modulesIn ./modules));
          specialArgs = {
            inherit
              inputs
              outputs
              this
              my
              ;
          };
        }
      ) (my.lib.catLowerAttrs "hardware-config" machines);
    };
}
