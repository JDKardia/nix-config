{ pkgs, ... }:
{

  home-manager.users.kardia = {

    home.packages = with pkgs; [
      monitorcontrol
      yabai
      skhd
      yubikey-manager
      ## archives
      zip
      xz
      unzip
      p7zip
      #slack
      #iterm2
      just
      tree
      gnused
      gnutar
      gnugrep
      gawk
      gnupg
      which
      file
      glow
      #_1password

      ## utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder
      fd # file finder

      #aria2 # A lightweight multi-protocol & multi-source command-line download utility
      #socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      coreutils
      moreutils

      ## misc
      #cowsay
      #file
      #which
      #tree
      #gnused
      #gnutar
      #gawk
      #zstd
      #caddy
      #gnupg

      ## productivity
      #glow # markdown previewer in terminal
    ];
  };
}
