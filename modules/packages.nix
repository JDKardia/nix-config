{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    # inputs.twdesktop.tiddlydesktop
    darktable

    atkinson-hyperlegible
    atkinson-monolegible

    # virtualisation
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    podman-compose # start group of containers for dev

    # core terminal utils
    btop
    coreutils-full
    grml-zsh-config
    htop
    iotop
    lshw
    moreutils
    netcat
    nettools
    nvtopPackages.full
    osquery
    pciutils
    sysstat
    file
    p7zip
    gtrash

    # general deps
    ffmpeg
    jdk
    pipewire
    jack2
    libjack2
    pavucontrol
    wineWowPackages.stable
    winetricks
    xfce.ristretto

    # nix related
    nixfmt-rfc-style
    deadnix
    comma
    manix
    statix
    nix-diff
    nixd
    nil

    # general tools
    gparted
    entr
    fd
    hyperfine
    jq
    neovim
    rclone
    ripgrep
    rsync
    tree
    unzip
    vim
    wget
    xclip
    zip
    wireguard-tools
    wireguard-ui
    transcrypt
    ruff
    (python312.withPackages (
      p:
      (with p; [
        python-lsp-ruff
        python-lsp-server
      ])
    ))
    rmlint
    czkawka-full
    clojure
    clojure-lsp
    leiningen
    clj-kondo
    joker
    babashka
    handbrake

    ghostty
    zig
    libgcc

  ];

  # enable jack2
  services.jack = {
    jackd.enable = true;
    # device depends on your audiocard (cat /proc/asound/cards)
    jackd.extraOptions = [
      "-dalsa"
      "--device"
      "hw:1"
      "--period"
      "128"
      "--nperiods"
      "2"
      "--rate"
      "48000"
    ];
    alsa.enable = false;
    loopback = {
      enable = true;
      dmixConfig = ''
        period_size 2048
      '';
    };
  };

}
