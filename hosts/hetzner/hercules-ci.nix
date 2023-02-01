{ pkgs, config, inputs, ... }:

{
  services.hercules-ci-agent = {
    enable = true;
    settings.binaryCachesPath = pkgs.writeTextFile { name = "binary-caches.json"; text = "{}"; };
    settings.secretsJsonPath = config.age.secrets.herculesSecrets.path;
    settings.clusterJoinTokenPath = config.age.secrets.herculesClusterJoinToken.path;
  };

  age.secrets = {
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
}
