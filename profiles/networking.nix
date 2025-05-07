{ inputs, ... }:

{
  imports = [
    (inputs.srvos.nixosModules.common + "/networking.nix")
    inputs.srvos.nixosModules.mixins-mdns
  ];
}
