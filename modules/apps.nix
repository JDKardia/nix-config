{ pkgs, ... }:
{
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
  ];
  home-manager.users.kardia = {

    home.packages = with pkgs; [
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
      findutils
      gawk
      gnupg
      coreutils
      moreutils
      nmap # A utility for network discovery and security auditing
      which
      shellcheck
      file
      glow
      direnv
      
      ## utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder
      fd # file finder


    ];
  };

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    # masApps = {
    #   # TODO Feel free to add your favorite apps here.

    #   Xcode = 497799835;
    #   # Wechat = 836500024;
    #   # NeteaseCloudMusic = 944848654;
    #   # QQ = 451108668;
    #   # WeCom = 1189898970;  # Wechat for Work
    #   # TecentMetting = 1484048379;
    #   # QQMusic = 595615424;
    # };

    taps = [
      "nikitabobko/tap"
      "koekeishiya/formulae"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "wget" # download tool
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "yabai"
      "skhd"
      "python"
      "awscli"
      "docker"
      "transcrypt"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "1password"
      "anki"
      "deezer"
      "firefox@developer-edition"
      "font-atkynson-mono-nerd-font"
      "font-fira-mono-nerd-font"
      "gimp"
      "google-chrome"
      "iterm2"
      "karabiner-elements"
      "obsidian"
      "pycharm"
      "slack"
      "stats"
      "visual-studio-code"
      "monitorcontrol"
    ];
  };
}
