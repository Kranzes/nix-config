{ lib, config, options, ... }:

{
  config = lib.mkMerge [
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
        authKeyFile = lib.mkDefault config.age.secrets.tailscale-auth-key.path;
      };

      age.secrets.tailscale-auth-key.file = lib.mkDefault ../secrets/all-tailscale-auth-key.age;
    }
    (lib.optionalAttrs (options ? environment.persistence) {
      environment.persistence."/nix/persistent".directories = [ "/var/lib/tailscale" ];
    })
  ];
}
