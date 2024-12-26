{ inputs, ... }:

{
  imports = [
    ./kanidm.nix
    ./grafana.nix
    ./prometheus.nix
    inputs.self.nixosModules.hosted-nginx
    inputs.self.nixosModules.hosted-node-exporter
  ];

  environment.persistence."/nix/persistent".directories = [
    "/var/lib/acme"
  ];
}
