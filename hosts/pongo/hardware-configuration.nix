{ inputs, pkgs, ... }:
let
  device = "/dev/nvme0n1";
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

  fileSystems = {
    "/home/4TB-HDD" = {
      device = "/dev/disk/by-uuid/7c126a7c-e8fd-4268-9cb8-4dba40a1aece";
      fsType = "ext4";
    };

    "/home/1TB-HDD" = {
      device = "/dev/disk/by-uuid/28bb79bc-ffb5-4e2b-8a1b-7cde40eeec9e";
      fsType = "ext4";
    };

    "/mnt/nextcloud/Music" = {
      device = "/home/4TB-HDD/Media/Music";
      fsType = "none";
      options = [ "bind" "ro" ];
    };
  };

  zramSwap.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "amd_iommu=on" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    tmp.cleanOnBoot = true;
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;
  };
  # For piper (Logitech mice crap).
  services.ratbagd.enable = true;
}
