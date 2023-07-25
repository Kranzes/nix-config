{ inputs, ... }:

{
  imports = [
    ./kanidm.nix
    inputs.self.nixosModules.nginx
  ];
}
