{
  lib,
  name,
  config,
  ...
}:
with lib;
with types; {
  freeformType = attrs;
  options = let
    mkConfigTypeOption = type:
      mkOption {
        description = "if this config describes a ${type}";
        type = bool;
        default = false;
      };
  in {
    hostname = mkOption {
      description = "The machine's hostname";
      type = nullOr str;
      default = name;
    };
    isServer = mkConfigTypeOption "server";
    isStation = mkConfigTypeOption "station";
    isLinux = mkConfigTypeOption "linux";
    isISO = mkConfigTypeOption "ISO";
    sshPort = mkOption {
      description = "The machine's SSH port";
      type = int;
      default = 22;
    };
  };
}
