{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.hosted-libvirt
  ];
}
