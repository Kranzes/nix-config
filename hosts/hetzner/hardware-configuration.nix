{ inputs, pkgs, ... }:
let
  device = "/dev/sda";
in
{
  imports = [
    inputs.srvos.nixosModules.hardware-hetzner-cloud
    inputs.disko.nixosModules.disko
  ];

  disko.devices.disk.main = {
    inherit device;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          type = "EF02";
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "xfs";
            mountpoint = "/";
          };
        };
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.systemd.enable = true;
    tmp.cleanOnBoot = true;
  };

  zramSwap.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  services.cloud-init.enable = false; # We don't make use of cloud-init at the moment.
}
