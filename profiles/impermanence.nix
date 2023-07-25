{ inputs, ... }:

{ config, lib, options, ... }:
let
  sshHostKeys = builtins.catAttrs "path" config.services.openssh.hostKeys;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  config = lib.mkMerge [
    {
      environment.persistence."/nix/persistent" = {
        hideMounts = true;
        directories = [
          "/var/log"
          "/var/lib/systemd/coredump"
          "/tmp" # Make builds not crash by running them on disk instead of RAM (We still clean /tmp on boot)
        ];
        files = [
          "/etc/machine-id"
        ] ++ sshHostKeys;
      };
    }
    (lib.optionalAttrs (options ? age) { age.identityPaths = map (x: "/nix/persistent" + x) sshHostKeys; })
  ];
}
