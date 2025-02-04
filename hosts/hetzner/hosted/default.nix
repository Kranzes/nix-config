{ inputs, ... }:

{
  imports = [
    ./kanidm.nix
    ./grafana.nix
    ./prometheus.nix
    ./homer.nix
    ./ntfy.nix
    inputs.self.nixosModules.hosted-nginx
    inputs.self.nixosModules.hosted-node-exporter
  ];
}
