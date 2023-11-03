{ inputs, ... }:

{ config, options, lib, ... }:

let
  sshHostKeys = builtins.catAttrs "path" config.services.openssh.hostKeys;
in
{
  imports = [ inputs.agenix.nixosModules.age ];

  age.identityPaths = lib.mkIf (options ? environment.persistence) (map (x: "/nix/persistent" + x) sshHostKeys);
}
