{ inputs, pkgs, lib, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-WDS100T3X0C-00SJG0_214242460714";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "512M";
            type = "EF00";
            label = "boot";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          nixos = {
            size = "100%";
            label = "nixos";
            content = {
              type = "luks";
              name = "cryptroot";
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

    "/mnt/nextcloud/yael" = {
      device = "/home/1TB-HDD/yael";
      fsType = "none";
      options = [ "bind" "rw" ];
    };
  };

  zramSwap.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-amd" "i2c-dev" "i2c_piix4" ];
    kernelParams = [ "amd_iommu=on" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
    initrd.systemd.enable = true;
  };


  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  services = {
    ratbagd.enable = true;
    fstrim.enable = true;
  };

  systemd.services."cooling-and-rgb-setup" = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      PrivateNetwork = true;
      ProtectHostname = true;
      LockPersonality = true;
      ProtectClock = true;
      ProtectHome = true;
      CapabilityBoundingSet = "";
      NoNewPrivileges = true;
    };
    script = ''
      echo "Initializing NZXT devices..."
      ${lib.getExe pkgs.liquidctl} initialize all > /dev/null
     
      echo "Configuring pump and fan speed for the AIO..."
      ${lib.getExe pkgs.liquidctl} --match "kraken" set pump speed 100
      ${lib.getExe pkgs.liquidctl} --match "kraken" set fan speed 70
    
      echo "Setting fan speed for the case fans..."
      ${lib.getExe pkgs.liquidctl} --match "smart device" set sync speed 100
    
      echo "Turning off all the LEDs..."
      ${lib.getExe pkgs.openrgb} --noautoconnect --mode off > /dev/null
    '';
  };
}
