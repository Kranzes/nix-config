{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hosted
    inputs.self.nixosModules.profiles-impermanence
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";
}
