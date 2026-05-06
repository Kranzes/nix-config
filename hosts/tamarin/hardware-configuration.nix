{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  device = "/dev/nvme0n1";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];

  disko.devices = {
    disk.${baseNameOf device} = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          nixos = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
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

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys.enable = true;
      configurationLimit = 8;
      measuredBoot = {
        enable = true;
        pcrs = [
          0
          #  1 Flaky, need to report the issue to Framework.
          2
          3
          4
          7
        ];
      };
    };
    loader.systemd-boot.enable = lib.mkForce (!config.boot.lanzaboote.enable);
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [ "amdgpu.abmlevel=0" ]; # Don't mess with my colors
    tmp.cleanOnBoot = true;
  };

  hardware = {
    enableAllFirmware = true;
    facter = {
      reportPath = ./facter.json;
      detected.dhcp.enable = false;
    };
  };
}
