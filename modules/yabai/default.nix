{ username, ... }:
{

  home-manager.users.${username} =
    {
      config,
      ...
    }:
    {
      home.file."${config.xdg.configHome}/yabai/yabairc" = {
          enable = true;
          force = true;
          source = ./yabairc;
        };
      home.file."${config.xdg.configHome}/skhd/skhdrc" = {
        enable = true;
        force=true;
        source = ./skhdrc;
      };
    };
}
