{ config, inputs, ... }:

{
  imports = [
    inputs.hercules-ci-agent.nixosModules.multi-agent-service
  ];

  services.hercules-ci-agents."kranzes".settings = {
    clusterJoinTokenPath = config.age.secrets.kranzes-hercules-cluster-join-token.path;
    secretsJsonPath = config.age.secrets.kranzes-hercules-secrets.path;
    binaryCachesPath = config.age.secrets.kranzes-hercules-binary-caches.path;
  };

  age.secrets = {
    kranzes-hercules-cluster-join-token = {
      file = ../../../secrets/${config.networking.hostName}-kranzes-hercules-cluster-join-token.age;
      owner = config.systemd.services.hercules-ci-agent-kranzes.serviceConfig.User;
    };
    kranzes-hercules-secrets = {
      file = ../../../secrets/${config.networking.hostName}-kranzes-hercules-secrets.age;
      owner = config.systemd.services.hercules-ci-agent-kranzes.serviceConfig.User;
    };
    kranzes-hercules-binary-caches = {
      file = ../../../secrets/${config.networking.hostName}-kranzes-hercules-binary-caches.age;
      owner = config.systemd.services.hercules-ci-agent-kranzes.serviceConfig.User;
    };
  };
}
