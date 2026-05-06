{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.srvos.nixosModules.mixins-systemd-boot
  ];

  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-WDS100T3X0C-00SJG0_214242460714";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "512M";
            type = "EF00";
            label = "boot";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          nixos = {
            size = "100%";
            label = "nixos";
            content = {
              type = "luks";
              name = "cryptroot";
              settings = {
                allowDiscards = true;
                bypassWorkqueues = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/home/4TB-HDD" = {
      device = "/dev/disk/by-uuid/7c126a7c-e8fd-4268-9cb8-4dba40a1aece";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
        "x-systemd.automount"
      ];
    };

    "/home/1TB-HDD" = {
      device = "/dev/disk/by-uuid/28bb79bc-ffb5-4e2b-8a1b-7cde40eeec9e";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
        "x-systemd.automount"
      ];
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  hardware = {
    enableAllFirmware = true;
    facter = {
      reportPath = ./facter.json;
      detected.dhcp.enable = false;
    };
  };

  boot = {
    kernelModules = [
      "i2c-dev"
      "i2c_piix4"
      "ntsync"
    ];
    kernelParams = [ "amd_iommu=on" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    tmp.cleanOnBoot = true;
    zswap.enable = true;
    loader.systemd-boot.windows."11".efiDeviceHandle = "HD0b";
  };

  powerManagement.cpuFreqGovernor = "performance";

  systemd.services."cooling-and-rgb-setup" = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      PrivateNetwork = true;
      ProtectHostname = true;
      LockPersonality = true;
      ProtectClock = true;
      ProtectHome = true;
      CapabilityBoundingSet = "";
      NoNewPrivileges = true;
    };
    script = ''
      echo "Initializing NZXT devices..."
      ${lib.getExe pkgs.liquidctl} initialize all > /dev/null

      echo "Configuring pump and fan speed for the AIO..."
      ${lib.getExe pkgs.liquidctl} --match "kraken" set pump speed 100
      ${lib.getExe pkgs.liquidctl} --match "kraken" set fan speed 70

      echo "Setting fan speed for the case fans..."
      ${lib.getExe pkgs.liquidctl} --match "smart device" set sync speed 100

      echo "Turning off all the LEDs..."
      ${lib.getExe pkgs.openrgb} --noautoconnect --mode off > /dev/null
    '';
  };
}
