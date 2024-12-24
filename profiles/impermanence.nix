{ inputs, ... }:

{ config, lib, options, ... }:
let
  sshHostKeys = builtins.catAttrs "path" config.services.openssh.hostKeys;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  config = {
    environment.persistence."/nix/persistent" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/log"
        "/var/lib/systemd"
        "/tmp" # Make builds not crash by running them on disk instead of RAM (We still clean /tmp on boot)
      ];
      files = [
        "/etc/machine-id"
      ] ++ sshHostKeys;
    };
  } // (lib.optionalAttrs (options ? age) { age.identityPaths = map (x: "/nix/persistent" + x) sshHostKeys; });
}
