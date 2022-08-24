{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/8fcc2565-6105-48cd-bfc1-0e1a11612c6d";
      fsType = "xfs";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/5001e9cb-3eb8-4086-9263-b64e372326d5"; }];
}
