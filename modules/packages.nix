{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    # inputs.twdesktop.tiddlydesktop
    darktable
    calibre
    calibre-web
    qbittorrent-enhanced
    filebot
    uv

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
    exiftool

    # general deps
    ffmpeg
    jdk
    pipewire
    jack2
    libjack2
    pavucontrol
    wineWow64Packages.stable
    winetricks
    ristretto
    appimage-run
    dolphin-emu
    retroarch-full
    # gst_all_1.gstreamer
    # gst_all_1.gst-plugins-base
    # gst_all_1.gst-plugins-good
    # gst_all_1.gst-plugins-ugly
    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi
    ffmpeg-headless
    ffmpegthumbnailer

    # nix related
    nixfmt
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
    (python3.withPackages (
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
