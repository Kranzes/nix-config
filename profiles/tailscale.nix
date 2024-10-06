{ lib, config, options, ... }:

{
  config = lib.mkMerge [
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = lib.mkDefault "client";
        extraSetFlags = lib.mkIf (lib.elem config.services.tailscale.useRoutingFeatures [ "both" "server" ]) [
          "--advertise-exit-node"
        ];
        authKeyFile = lib.mkDefault config.age.secrets.tailscale-auth-key.path;
      };

      age.secrets.tailscale-auth-key.file = lib.mkDefault ../secrets/all-tailscale-auth-key.age;
    }
    (lib.optionalAttrs (options ? environment.persistence) {
      environment.persistence."/nix/persistent".directories = [ "/var/lib/tailscale" ];
    })
  ];
}
