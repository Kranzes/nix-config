{ modulesPath, inputs, pkgs, lib, ... }:

let
  device = "/dev/sda";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk.${baseNameOf device} = {
      inherit device;
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "boot";
            start = "0";
            end = "1M";
            flags = [ "bios_grub" ];
          }
          {
            name = "ESP";
            start = "1M";
            end = "512M";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "nix";
            start = "512M";
            end = "100%";
            part-type = "primary";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/nix";
            };
          }
        ];
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
        "defaults"
        "mode=755"
      ];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.systemd.enable = true;
    cleanTmpDir = true;
    loader.grub = {
      enable = true;
      inherit device;
    };
  };

  zramSwap.enable = true;
}
