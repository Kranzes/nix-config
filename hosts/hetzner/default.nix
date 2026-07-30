{
  lib,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hosted
    inputs.srvos.nixosModules.server
    "${modulesPath}/profiles/minimal.nix"
  ];

  time.timeZone = "UTC";

  networking.useDHCP = lib.mkForce true;

  security.run0.wheelNeedsPassword = false;

  system.stateVersion = "25.05";
}
