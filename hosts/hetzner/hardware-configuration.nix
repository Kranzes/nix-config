{ modulesPath, inputs, pkgs, ... }:

let
  device = "/dev/sda";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
  ];

  disko.devices.disk.${baseNameOf device} = {
    inherit device;
    type = "disk";
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          name = "boot";
          type = "partition";
          start = "0";
          end = "512M";
          part-type = "primary";
          flags = [ "bios_grub" ];
        }
        {
          name = "root";
          type = "partition";
          start = "512M";
          end = "100%";
          part-type = "primary";
          bootable = true;
          content = {
            type = "filesystem";
            format = "xfs";
            mountpoint = "/";
          };
        }
      ];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      enable = true;
      inherit device;
    };
  };

  zramSwap.enable = true;
}
