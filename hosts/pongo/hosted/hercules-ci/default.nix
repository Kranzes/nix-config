{ pkgs, config, inputs, ... }:

{

  imports = [ ./multi ];

  services.hercules-ci-agents."kranzes" = {
    enable = true;
    package = (builtins.getFlake "github:hercules-ci/hercules-ci-agent/e44538cf90ecd8173a6edf75f9a14364d3b9962f").packages.${pkgs.system}.hercules-ci-agent;
    settings = {
      binaryCachesPath = pkgs.writeText "binary-caches.json" "{}";
      secretsJsonPath = config.age.secrets.hercules-kranzes-secrets.path;
      clusterJoinTokenPath = config.age.secrets.hercules-kranzes-cluster-join-token.path;
    };
  };

  age.secrets = {
    hercules-kranzes-secrets = {
      file = "${inputs.self}/secrets/${config.networking.hostName}-kranzes-hercules-secrets.age";
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
    hercules-kranzes-cluster-join-token = {
      file = "${inputs.self}/secrets/${config.networking.hostName}-kranzes-hercules-cluster-join-token.age";
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
  };
}
