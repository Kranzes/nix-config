{ inputs, pkgs, config, lib, ... }:
let
  device = "/dev/nvme0n1";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
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
            start = "1MiB";
            end = "512MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "nixos";
            start = "512MiB";
            end = "100%";
            part-type = "primary";
            bootable = true;
            content = {
              type = "luks";
              name = "cryptroot";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          }
        ];
      };
    };
  };

  zramSwap.enable = true;

  boot = {
    lanzaboote.enable = true;
    lanzaboote.pkiBundle = "/etc/secureboot";
    loader.systemd-boot.enable = lib.mkForce (!config.boot.lanzaboote.enable);
    loader.efi.canTouchEfiVariables = true;
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
