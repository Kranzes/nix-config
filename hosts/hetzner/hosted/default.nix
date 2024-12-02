{ inputs, ... }:

{
  imports = [
    ./kanidm.nix
    inputs.self.nixosModules.hosted-nginx
  ];
}
