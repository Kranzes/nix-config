{
  inputs,
  pkgs,
  config,
  ...
}:

let
  device = "/dev/sda";
in
{
  imports = [
    inputs.disko.nixosModules.disko
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
            type = "EF00";
            size = "512M";
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
              name = "cryptroot";
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
    initrd.systemd.enable = true;
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "sd_mod"
      "sdhci_pci"
    ];
    kernelModules = [
      "kvm-intel"
      "acpi_call"
    ];
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
