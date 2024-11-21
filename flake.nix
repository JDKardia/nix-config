{
  description = "kardia's nix config";
  inputs = {
    # Nixpkgs: nixos-unstable head as of 2024-11-13
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.follows = "nixpkgs";

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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    my = import ./lib nixpkgs.lib machines;
    machines = my.lib.exprsIn ./machines;
    system = "x86_64-linux";
    inherit (self) outputs;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = nixpkgs.lib.mapAttrs (
      host: hardware-config: let
        this = my.machines.${host};
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            (nixpkgs.lib.attrValues (my.lib.modulesIn ./modules))
            ++ [
              hardware-config
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {inherit inputs outputs this my;};
                };
              }
            ];
          specialArgs = {
            inherit inputs outputs this my;
            myModulesPath = toString ./modules;
            # hardware = nixpkgs.nixosModules // inputs.nixos-hardware.nixosModules;
            # pkgsBase = pkgs; # for use in imports without infinite recursion
          };
        }
    ) (my.lib.catLowerAttrs "hardware-config" machines);
  };
}
