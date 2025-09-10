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
    inputs.srvos.nixosModules.mixins-systemd-boot
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
            };
          };
          nixos = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
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

  zramSwap.enable = true;

  boot = {
    lanzaboote.enable = true;
    lanzaboote.pkiBundle = "/var/lib/sbctl";
    loader.systemd-boot.enable = lib.mkForce (!config.boot.lanzaboote.enable);
    initrd.systemd.enable = true;
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
    ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_testing;
    kernelParams = [ "amdgpu.abmlevel=0" ]; # Don't mess with my colors
    tmp.cleanOnBoot = true;
  };

  hardware = {
    enableAllHardware = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;
  };

  services = {
    tuned = {
      enable = true;
      ppdSettings = {
        main.default = "power-saver";
        battery = {
          inherit (config.services.tuned.ppdSettings.profiles) power-saver;
        };
      };
    };
    tlp.enable = false;
    upower.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
  };
}
