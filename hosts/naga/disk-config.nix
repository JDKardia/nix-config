{
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
                extraArgs = ["-F32"];
                mountpoint = "/boot";
                mountOptions = ["defaults"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt";
                extraOpenArgs = [];
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
                extraOpenArgs = [];
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
              extraArgs = ["--force"];
              subvolumes = {
                "@root" = {
                  mountOptions = ["noatime" "compress=zstd" "ssd" "commit=15"];
                  mountpoint = "/";
                };
                "@home" = {
                  mountOptions = ["noatime" "compress=zstd" "ssd" "commit=15"];
                  mountpoint = "/home";
                };
                "@kardia" = {
                  mountOptions = ["noatime" "compress=zstd" "ssd" "commit=15"];
                  mountpoint = "/home/kardia";
                };
                "@nix" = {
                  mountOptions = ["noatime" "compress=zstd" "ssd" "commit=15"];
                  mountpoint = "/nix";
                };
                "@persist" = {
                  mountOptions = ["noatime" "compress=zstd" "ssd" "commit=15"];
                  mountpoint = "/persist";
                };
                "@log" = {
                  mountOptions = ["noatime" "compress=zstd" "ssd" "commit=15"];
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
              extraArgs = ["--force"];
              subvolumes = {
                "@hoard" = {
                  mountOptions = ["noatime" "compress=zstd" "ssd" "commit=15"];
                  mountpoint = "/home/kardia/hoard";
                };
              };
            };
          };
        };
      };
    };
  };
}
