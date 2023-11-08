{ inputs, ... }:

{
  imports = [
    ./kanidm.nix
    inputs.self.nixosModules.hosted-nginx
    inputs.self.nixosModules.hosted-grafana-agent
  ];
}
