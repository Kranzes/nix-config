{ inputs, config, ... }:

{
  services.cachix-agent = {
    enable = true;
    credentialsFile = config.age.secrets.cachix-deploy-agent.path;
  };

  age.secrets.cachix-deploy-agent.file = "${inputs.self}/secrets/${config.networking.hostName}-cachix-deploy-agent.age";
}
