# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.common-hidpi
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # TODO
  # setup hibernation: https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221
  #
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  #boot.loader.grub.devices = ["nodev"];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.command-not-found = {
    enable = true;
    dbPath = "${inputs.programs-db}/programs.sqlite";
  };
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";
  services.xserver.monitorSection = lib.mkDefault ''
    DisplaySize 344 193
  '';
  hardware.opengl.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
    #forceFullCompositionPipeline = true;
  };
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "naga";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    kardia = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "pipewire"];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useUserPackages = true;
    users = {
      # Import your home-manager configuration
      kardia = import ../home-manager/home.nix;
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };
  time.timeZone = lib.mkDefault "America/Chicago";

  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    podman-compose # start group of containers for dev
    btop
    coreutils-full
    fd
    ffmpeg
    gimp
    gnome.gnome-tweaks
    grml-zsh-config
    hyperfine
    iotop
    jq
    lshw
    moreutils
    mpv
    neovim
    netcat
    nettools
    nvtopPackages.full
    obs-studio
    osquery
    pciutils
    pipewire
    rclone
    ripgrep
    chromium
    rsync
    steam
    sysstat
    tree
    unzip
    vim
    vlc
    wget
    xclip
    zip
    zsh
    htop
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["kardia"];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    resolutions = [
      {
        x = 2560;
        y = 1440;
      }
    ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable the GNOME Desktop Environment.

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05";
}
