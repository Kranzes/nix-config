{ config, inputs, ... }:

{
  services.hercules-ci-agent = {
    enable = true;
    settings.binaryCachesPath = config.age.secrets.herculesBinaryCaches.path;
    settings.secretsJsonPath = config.age.secrets.herculesSecrets.path;
    settings.clusterJoinTokenPath = config.age.secrets.herculesClusterJoinToken.path;
  };

  age.secrets = {
    herculesBinaryCaches = {
      file = "${inputs.self}/secrets/herculesBinaryCaches.age";
      group = "hercules-ci-agent";
      owner = "hercules-ci-agent";
    };
    herculesSecrets = {
      file = "${inputs.self}/secrets/herculesSecrets.age";
      group = "hercules-ci-agent";
      owner = "hercules-ci-agent";
    };
    herculesClusterJoinToken = {
      file = "${inputs.self}/secrets/${config.networking.hostName}-herculesClusterJoinToken.age";
      group = "hercules-ci-agent";
      owner = "hercules-ci-agent";
    };
  };

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "monthly";
  };
}
