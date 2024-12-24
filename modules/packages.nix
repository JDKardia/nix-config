{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default

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

    # general tools/deps
    ffmpeg
    jdk
    pipewire

    # nix related
    nixfmt-rfc-style
    deadnix
    comma
    manix
    statix
    nix-diff

    # general tools
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

  ];
}
