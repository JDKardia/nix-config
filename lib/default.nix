np: machine_list: rec {
  # constants for reference
  nixConfig = ".config/nix";
  binHome = ".local/bin";
  machines = lib.catLowerAttrs "identity" machine_list;
  user = "kardia";
  ssh_public_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPVRNgFTItxuUkzDsPwFBnMJkGzCi8T3kDscim5I84UE kardia@naga"
  ];

  # functions for general use
  lib = rec {
    # Collects the top-level modules in a directory into an attribute set of paths.
    # A module `foo` can be either a file (`foo.nix`) or a directory (`foo/default.nix`).
    modulesIn = dir:
      np.pipe dir [
        builtins.readDir
        (np.mapAttrsToList (
          name: type:
            if type == "regular" && np.hasSuffix ".nix" name && name != "default.nix"
            then [
              {
                name = np.removeSuffix ".nix" name;
                value = dir + "/${name}";
              }
            ]
            else if type == "directory" && np.pathExists (dir + "/${name}/default.nix")
            then [
              {
                inherit name;
                value = dir + "/${name}";
              }
            ]
            else []
        ))
        np.concatLists
        np.listToAttrs
      ];

    # Like modulesIn, but imports the files.
    exprsIn = dir: np.mapAttrs (_: import) (modulesIn dir);

    # Like catAttrs, but operates on an attribute set of attribute sets
    # instead of a list of attribute sets.
    # formerly catAttrs',
    catLowerAttrs = key: set:
      np.listToAttrs (np.concatMap (
        name: let
          v = set.${name};
        in
          if v ? ${key}
          then [(np.nameValuePair name v.${key})]
          else []
      ) (np.attrNames set));

    # Collects the inputs of a flake recursively (with possible duplicates).
    collectFlakeInputs = input:
      [input] ++ np.concatMap np.collectFlakeInputs (builtins.attrValues (input.inputs or {}));

    # Gets all the outputs of a derivation as a list.
    getAllOutputs = drv:
      if drv ? outputs
      then np.attrVals drv.outputs drv
      else [drv];

    versionAtMost = a: b: np.versionAtLeast b a;

    # Creates a simple module with an `enable` option.
    mkEnableModule = name: cfg: {
      options = np.setAttrByPath name {enable = np.mkEnableOption (np.last name);};
      imports = [({config, ...}: {config = np.mkIf (np.getAttrFromPath name config).enable cfg;})];
    };
  };
}
