{ config, self, ... }:

{
  services.cachix-agent = {
    enable = true;
    credentialsFile = config.age.secrets.cachix-deploy-agent.path;
  };

  age.secrets.cachix-deploy-agent.file = "${self}/secrets/${config.services.cachix-agent.name}-cachix-deploy-agent.age";
}
