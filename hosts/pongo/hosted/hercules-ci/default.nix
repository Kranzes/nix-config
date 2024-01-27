{ pkgs, config, ... }:

{

  imports = [ ./multi ];

  services.hercules-ci-agents."kranzes" = {
    enable = true;
    package = (builtins.getFlake "github:hercules-ci/hercules-ci-agent/f01ae96b022bb12d35d7223548a0b05623a55ddf").packages.${pkgs.system}.hercules-ci-agent;
    settings = {
      clusterJoinTokenPath = config.age.secrets.kranzes-hercules-cluster-join-token.path;
      secretsJsonPath = config.age.secrets.kranzes-hercules-secrets.path;
      binaryCachesPath = config.age.secrets.kranzes-hercules-binary-caches.path;
    };
  };

  age.secrets = {
    kranzes-hercules-cluster-join-token = {
      file = ../../../../secrets/${config.networking.hostName}-kranzes-hercules-cluster-join-token.age;
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
    kranzes-hercules-secrets = {
      file = ../../../../secrets/${config.networking.hostName}-kranzes-hercules-secrets.age;
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
    kranzes-hercules-binary-caches = {
      file = ../../../../secrets/${config.networking.hostName}-kranzes-hercules-binary-caches.age;
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
  };
}
