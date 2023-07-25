{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hosted
    inputs.self.nixosModules.impermanence
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";
}
