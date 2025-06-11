{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # utils for this project
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nixvim,
      lix-module,
      treefmt-nix,
      ...
    }:
    let
      inherit (self) outputs;
      # TODO replace with your own username, email, system, and hostname
      allSystems = [ "aarch64-darwin" ]; # aarch64-darwin or x86_64-darwin
      # Collects the top-level modules in a directory into an attribute set of paths.
      # A module `foo` can be either a file (`foo.nix`) or a directory (`foo/default.nix`).
      modulesIn =
        dir:
        nixpkgs.lib.pipe dir [
          builtins.readDir
          (nixpkgs.lib.mapAttrsToList (
            name: type:
            if type == "regular" && nixpkgs.lib.hasSuffix ".nix" name && name != "default.nix" then
              [
                {
                  name = nixpkgs.lib.removeSuffix ".nix" name;
                  value = dir + "/${name}";
                }
              ]
            else if type == "directory" && nixpkgs.lib.pathExists (dir + "/${name}/default.nix") then
              [
                {
                  inherit name;
                  value = dir + "/${name}";
                }
              ]
            else
              [ ]
          ))
          nixpkgs.lib.concatLists
          nixpkgs.lib.listToAttrs
        ];

      # Like modulesIn, but imports the files.

      # pkgs = import nixpkgs {
      #   inherit system;
      #   overlays = [
      #     (_self: _super: { nordvpn = import ./pkgs/nordvpn { }; })
      #     niri.overlays.niri
      #   ];
      # };
    in
    {
      formatter = nixpkgs.lib.genAttrs allSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
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
        in
        treefmt.config.build.wrapper
      );
      darwinConfigurations = {
        "DV-JV7QTHPR6L" =
          let
            system = "aarch64-darwin";
            username = "kardia";
            hostname = "DV-JV7QTHPR6L";
          in
          nix-darwin.lib.darwinSystem {
            inherit system;

            specialArgs = {
              inherit
                inputs
                outputs
                username
                hostname
                ;
            };
            modules = [
              lix-module.nixosModules.default
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.sharedModules = [
                  nixvim.homeManagerModules.nixvim
                ];
                home-manager.extraSpecialArgs = {
                  inherit
                    inputs
                    outputs
                    username
                    hostname
                    ;
                };
              }
            ] ++ (nixpkgs.lib.attrValues (modulesIn ./modules));
          };
      };

    };
}
