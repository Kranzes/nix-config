{ pkgs, config, ... }:

{

  imports = [ ./multi ];

  services.hercules-ci-agents."kranzes" = {
    enable = true;
    package = (builtins.getFlake "github:hercules-ci/hercules-ci-agent/e44538cf90ecd8173a6edf75f9a14364d3b9962f").packages.${pkgs.system}.hercules-ci-agent;
    settings = {
      binaryCachesPath = pkgs.writeText "binary-caches.json" "{}";
      secretsJsonPath = config.age.secrets.herculesSecrets.path;
      clusterJoinTokenPath = config.age.secrets.herculesClusterJoinToken.path;
    };
  };

  age.secrets = {
    herculesSecrets = {
      rekeyFile = ./herculesSecrets.age;
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
    herculesClusterJoinToken = {
      rekeyFile = ./${config.networking.hostName}-herculesClusterJoinToken.age;
      owner = config.services.hercules-ci-agents.kranzes.user;
      inherit (config.services.hercules-ci-agents.kranzes) group;
    };
  };
}
