{ inputs, pkgs, config, ... }:

let
  device = "/dev/sda";
in
{
  imports = [
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
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
    kernelModules = [ "kvm-intel" "acpi_call" ];
    kernelParams = [ "i915.fastboot=1" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
  };

  powerManagement.cpuFreqGovernor = "conservative";

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    thinkfan.enable = true;
  };
}
