{ username, ... }:
{

  home-manager.users.${username} =
    {
      config,
      ...
    }:
    {
      home.file."${config.xdg.configHome}/karabiner/assets/complex_modifications/karabiner-custom-shit.json" =
        {
          enable = true;
          force=true;
          source = ./karabiner-custom-shit.json;
        };
      home.file."${config.xdg.configHome}/karabiner/karabiner.json" = {
        enable = true;
        force=true;
        source = ./karabiner.json;
      };
    };
}
