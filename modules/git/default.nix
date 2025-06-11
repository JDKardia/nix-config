_: {

  home-manager.users.kardia = {

    programs.git = {
      enable = true;
      userName = "Kardia";
      userEmail = "joe@kardia.codes";
    };
    programs.jujutsu = {
      enable = true;
    };
  };
}
