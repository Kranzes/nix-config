{ inputs, pkgs, config, lib, ... }:
let
  device = "/dev/nvme0n1";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.srvos.nixosModules.mixins-systemd-boot
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
    lanzaboote.pkiBundle = "/etc/secureboot";
    loader.systemd-boot.enable = lib.mkForce (!config.boot.lanzaboote.enable);
    initrd.systemd.enable = true;
    initrd.availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "acpi_backlight=native" "mem_sleep_default=deep" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
  };


  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    trackpoint = {
      enable = true;
      emulateWheel = true;
      device = "ETPS/2 Elantech TrackPoint";
    };
  };

  powerManagement.cpuFreqGovernor = "conservative";

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    thinkfan.enable = true;
  };
}
