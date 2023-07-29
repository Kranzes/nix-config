{ inputs, ... }:

{ pkgs, lib, config, options, ... }:

{
  imports = [ inputs.agenix.nixosModules.age ];

  config = lib.mkMerge [
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
        authKeyFile = lib.mkDefault config.age.secrets.tailscaleAuthKey.path;
      };

      age.secrets.tailscaleAuthKey.file = lib.mkDefault "${inputs.self}/secrets/infra-tailscaleAuthKey.age";
    }
    (lib.optionalAttrs (options ? environment.persistence) {
      environment.persistence."/nix/persistent".directories = [ "/var/lib/tailscale" ];
    })
  ];
}
