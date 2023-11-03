{ pkgs, config, inputs, ... }:

{

  imports = [ ./multi ];

  services.hercules-ci-agents."kranzes" = {
    enable = true;
    package = (builtins.getFlake "github:hercules-ci/hercules-ci-agent/e44538cf90ecd8173a6edf75f9a14364d3b9962f").packages.${pkgs.system}.hercules-ci-agent;
    settings = {
      clusterJoinTokenPath = config.age.secrets.kranzes-hercules-cluster-join-token.path;
      secretsJsonPath = config.age.secrets.kranzes-hercules-secrets.path;
      binaryCachesPath = config.age.secrets.kranzes-hercules-binary-caches.path;
    };
  };

  age.secrets = {
    kranzes-hercules-cluster-join-token = {
      file = "${inputs.self}/secrets/${config.networking.hostName}-kranzes-hercules-cluster-join-token.age";
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
    kranzes-hercules-secrets = {
      file = "${inputs.self}/secrets/${config.networking.hostName}-kranzes-hercules-secrets.age";
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
    kranzes-hercules-binary-caches = {
      file = "${inputs.self}/secrets/${config.networking.hostName}-kranzes-hercules-binary-caches.age";
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
  };
}
