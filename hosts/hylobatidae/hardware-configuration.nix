{ config, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a58327e6-8fdf-45d5-b977-739728f91d4a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/249A-BABF";
    fsType = "vfat";
  };
}
