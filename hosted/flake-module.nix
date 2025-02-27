{ inputs, lib, ... }:

{
  flake.nixosModules = {
    hosted-nginx = lib.modules.importApply ./nginx.nix { inherit inputs; };
    hosted-node-exporter = ./node-exporter.nix;
    hosted-restic = ./restic.nix;
    hosted-libvirt = ./libvirt.nix;
  };
}
