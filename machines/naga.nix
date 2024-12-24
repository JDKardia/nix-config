{
  # TODO
  # setup hibernation: https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221
  #
  identity = {
    isStation = true;
    isLinux = true;
    # system = "x86_64-linux";
    syncthing.id = "SDYW25Q-XXVPJEI-4HHPGEQ-KDYRWLC-WI6BCHB-2WH2SBQ-HU4HGKH-5FZZ6QM";
    wireguard = {
      ipv4 = "10.10.1.1";
      ipv6 = "fd00::1:1";
    };
  };

  hardware-config =
    {
      inputs,
      lib,
      config,
      modulesPath,
      ...
    }:
    {
      networking = {
        hostName = "naga";
        # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
        # (the default) this is the recommended approach. When using systemd-networkd it's
        # still possible to use this option, but it's recommended to use it in conjunction
        # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
        useDHCP = lib.mkDefault true;
        interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
      };
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.hardware.nixosModules.common-cpu-intel
        inputs.hardware.nixosModules.common-pc-laptop-ssd
        inputs.hardware.nixosModules.common-hidpi
        inputs.disko.nixosModules.disko
      ];

      # Use the systemd-boot EFI boot loader.
      boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        initrd.availableKernelModules = [
          "xhci_pci"
          "nvme"
          "usb_storage"
          "sd_mod"
          "sdhci_pci"
        ];
        initrd.kernelModules = [ "dm-snapshot" ];
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
      };

      hardware = {
        trackpoint.device = "TPPS/2 Elan TrackPoint";

        graphics.enable = true;
        nvidia = {
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
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
      # fix monitor sizing
      services.xserver = {
        enable = true;
        videoDrivers = [ "nvidia" ];
        resolutions = [
          {
            x = 2560;
            y = 1440;
          }
        ];
        monitorSection = lib.mkDefault ''
          DisplaySize 344 193
        '';
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      disko.devices = {
        disk = {
          nvme0n1 = {
            type = "disk";
            device = "/dev/nvme0n1";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  name = "boot";
                  size = "500M";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    extraArgs = [ "-F32" ];
                    mountpoint = "/boot";
                    mountOptions = [ "defaults" ];
                  };
                };
                luks = {
                  size = "100%";
                  content = {
                    type = "luks";
                    name = "crypt";
                    extraOpenArgs = [ ];
                    passwordFile = "/tmp/passphrase";
                    settings = {
                      allowDiscards = true;
                    };
                    content = {
                      type = "lvm_pv";
                      vg = "crypt";
                    };
                  };
                };
              };
            };
          };
          nvme1n1 = {
            type = "disk";
            device = "/dev/nvme1n1";
            content = {
              type = "gpt";
              partitions = {
                luks = {
                  size = "100%";
                  content = {
                    type = "luks";
                    name = "hoard";
                    extraOpenArgs = [ ];
                    passwordFile = "/tmp/passphrase";
                    settings = {
                      allowDiscards = true;
                    };
                    content = {
                      type = "lvm_pv";
                      vg = "hoard";
                    };
                  };
                };
              };
            };
          };
        };
        lvm_vg = {
          crypt = {
            type = "lvm_vg";
            lvs = {
              swap = {
                size = "64GiB";
                content = {
                  type = "swap";
                  resumeDevice = true;
                };
              };
              data = {
                size = "100%FREE";
                content = {
                  type = "btrfs";
                  extraArgs = [ "--force" ];
                  subvolumes = {
                    "@root" = {
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "ssd"
                        "commit=15"
                      ];
                      mountpoint = "/";
                    };
                    "@home" = {
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "ssd"
                        "commit=15"
                      ];
                      mountpoint = "/home";
                    };
                    "@kardia" = {
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "ssd"
                        "commit=15"
                      ];
                      mountpoint = "/home/kardia";
                    };
                    "@nix" = {
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "ssd"
                        "commit=15"
                      ];
                      mountpoint = "/nix";
                    };
                    "@persist" = {
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "ssd"
                        "commit=15"
                      ];
                      mountpoint = "/persist";
                    };
                    "@log" = {
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "ssd"
                        "commit=15"
                      ];
                      mountpoint = "/var/log";
                    };
                  };
                };
              };
            };
          };
          hoard = {
            type = "lvm_vg";
            lvs = {
              data = {
                size = "100%FREE";
                content = {
                  type = "btrfs";
                  extraArgs = [ "--force" ];
                  subvolumes = {
                    "@hoard" = {
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                        "ssd"
                        "commit=15"
                      ];
                      mountpoint = "/home/kardia/hoard";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
}
