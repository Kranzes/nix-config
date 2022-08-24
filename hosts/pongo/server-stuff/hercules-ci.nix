{ config, self, ... }:

{
  services.hercules-ci-agent = {
    enable = true;
    settings.binaryCachesPath = config.age.secrets.herculesBinaryCaches.path;
    settings.secretsJsonPath = config.age.secrets.herculesSecrets.path;
    settings.clusterJoinTokenPath = config.age.secrets.herculesClusterJoinToken.path;
  };

  age.secrets = {
    herculesBinaryCaches = {
      file = "${self}/secrets/herculesBinaryCaches.age";
      group = "hercules-ci-agent";
      owner = "hercules-ci-agent";
    };
    herculesSecrets = {
      file = "${self}/secrets/herculesSecrets.age";
      group = "hercules-ci-agent";
      owner = "hercules-ci-agent";
    };
    herculesClusterJoinToken = {
      file = "${self}/secrets/${config.networking.hostName}-herculesClusterJoinToken.age";
      group = "hercules-ci-agent";
      owner = "hercules-ci-agent";
    };
  };
}
