{ inputs, ... }:

{ config, options, ... }:

let
  sshHostKeys = builtins.catAttrs "path" config.services.openssh.hostKeys;
in
{
  imports = [ inputs.agenix.nixosModules.age ];

  age.identityPaths = if (options ? environment.persistence) then (map (x: "/nix/persistent" + x) sshHostKeys) else sshHostKeys;
}
