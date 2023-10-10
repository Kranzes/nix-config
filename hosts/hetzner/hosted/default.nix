{ inputs, ... }:

{
  imports = [
    ./kanidm.nix
    inputs.self.nixosModules.nginx
    inputs.self.nixosModules.grafana-agent
  ];
}
