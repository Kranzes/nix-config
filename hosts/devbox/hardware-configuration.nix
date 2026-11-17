{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  disks = lib.mapAttrsToList (_: disk: disk.device) config.disko.devices.disk;
in
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = lib.genAttrs [ "nvme0n1" "nvme1n1" ] (name: {
      device = "/dev/${name}";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          bios = {
            size = "1M";
            type = "EF02";
          };
          boot = {
            size = "1G";
            content = {
              type = "mdraid";
              name = "boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "root";
            };
          };
        };
      };
    });
    mdadm = {
      boot = {
        type = "mdadm";
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      root = {
        type = "mdadm";
        level = 0;
        content = {
          type = "filesystem";
          format = "xfs";
          mountpoint = "/";
        };
      };
    };
  };

  boot = {
    loader.limine = {
      enable = true;
      efiSupport = false;
      biosDevice = lib.head disks;
      partitionIndex = 1;
      maxGenerations = 5;
      extraConfig = "serial: yes";
      extraInstallCommands = lib.concatMapStringsSep "\n" (
        disk: "${lib.getExe config.boot.loader.limine.package} bios-install ${disk} 1"
      ) (lib.tail disks);
    };
    swraid.mdadmConf = "MAILADDR root";
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "nvme_core.io_timeout=4294967295"
      "fuse.enable_uring=1"
    ];
  };
}
