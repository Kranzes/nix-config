{ pkgs, config, ... }:

{
  services.hercules-ci-agent = {
    enable = true;
    settings.binaryCachesPath = pkgs.writeText "binary-caches.json" "{}";
    settings.secretsJsonPath = config.age.secrets.herculesSecrets.path;
    settings.clusterJoinTokenPath = config.age.secrets.herculesClusterJoinToken.path;
  };

  age.secrets = {
    herculesSecrets = {
      rekeyFile = ./herculesSecrets.age;
      group = "hercules-ci-agent";
      owner = "hercules-ci-agent";
    };
    herculesClusterJoinToken = {
      rekeyFile = ./${config.networking.hostName}-herculesClusterJoinToken.age;
      group = "hercules-ci-agent";
      owner = "hercules-ci-agent";
    };
  };
}
