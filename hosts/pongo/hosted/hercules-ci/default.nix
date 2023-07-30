{ pkgs, config, ... }:

{
  services.hercules-ci-agent = {
    enable = true;
    # I want 0.9.12 now!!!
    package = (builtins.getFlake "github:NixOS/nixpkgs/23bb7c65c37945745c87ad9f002a428d51753b13").legacyPackages.${pkgs.system}.hercules-ci-agent;
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
