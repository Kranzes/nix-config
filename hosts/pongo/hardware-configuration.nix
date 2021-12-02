{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/e87cde1b-6e9d-477d-9c54-b28b3c559da5";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/58FE-599A";
      fsType = "vfat";
    };

  fileSystems."/home/4TB-HDD" =
    {
      device = "/dev/disk/by-uuid/7c126a7c-e8fd-4268-9cb8-4dba40a1aece";
      fsType = "ext4";
    };

  fileSystems."/home/1TB-HDD" =
    {
      device = "/dev/disk/by-uuid/28bb79bc-ffb5-4e2b-8a1b-7cde40eeec9e";
      fsType = "ext4";
    };

  fileSystems."/mnt/nextcloud/Music" =
    {
      device = "/home/4TB-HDD/Media/Music";
      fsType = "none";
      options = [ "bind" "ro" ];
    };

  swapDevices = [{ device = "/swapfile"; size = 16384; }];

  hardware = {
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;
  };
}
