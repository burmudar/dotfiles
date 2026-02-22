{
  disko.devices = {
    disk = {
      # OS disk (encrypted)
      nvme0n1 = {
        imageSize = "15G";
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "noatime" "fmask=0077" "dmask=0077" ];
              };
            };

            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-L" "nixos" "-f" ];
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "subvol=@root"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "subvol=@home"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=@nix"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                      ];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "subvol=@log"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                      ];
                    };
                    "@varlib" = {
                      mountpoint = "/var/lib";
                      mountOptions = [
                        "subvol=@varlib"
                        "compress=zstd:3"
                        "noatime"
                        "ssd"
                        "space_cache=v2"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };

      # Steam disk (unencrypted)
      nvme1n1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            steam = {
              name = "steam";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/games";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  # tmp in RAM (avoid disk churn)
  fileSystems."/tmp" = {
    fsType = "tmpfs";
    options = [ "mode=1777" "size=8G" ];
  };
}
