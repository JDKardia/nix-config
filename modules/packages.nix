# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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

    # general tools/deps
    ffmpeg
    jdk
    pipewire

    # nix related
    alejandra
    deadnix
    comma
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
  ];
}
