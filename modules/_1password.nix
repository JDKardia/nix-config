_: {
  # Enable common container config files in /etc/containers
  security.polkit.enable = true;
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "kardia" ];
    };
  };
}
