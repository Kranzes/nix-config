{
  flake.nixosModules = {
    hosted-grafana-agent = ./grafana-agent.nix;
    hosted-nginx = ./nginx.nix;
  };
} 
