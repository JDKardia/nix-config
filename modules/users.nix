{ pkgs, ... }:
{
  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    kardia = {
      # skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change using `passwd` after rebooting!
      shell = pkgs.zsh;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [
        "wheel"
        "networkmanager"
        "pipewire"
        "jackaudio"
      ];
    };
  };
  systemd.settings.Manager.DefaultLimitNOFILE = 524288;
  security.pam.loginLimits = [
    {
      domain = "kardia";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];
}
