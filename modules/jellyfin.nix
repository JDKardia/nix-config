_:
let
  jfDir = "/home/kardia/hoard/jellyfin";
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "kardia";
    configDir = "${jfDir}/config";
    dataDir = "${jfDir}/data";
    cacheDir = "${jfDir}/cache";
    logDir = "${jfDir}/log";
  };
}
