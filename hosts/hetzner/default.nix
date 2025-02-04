{ lib, inputs, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hosted
    inputs.srvos.nixosModules.server
    "${modulesPath}/profiles/minimal.nix"
  ];

  time.timeZone = "UTC";

  networking.useDHCP = lib.mkForce true;

  system.stateVersion = "25.05";
}
