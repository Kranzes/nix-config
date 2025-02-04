{ inputs, ... }:
{ config, ... }:
{
  imports = [ inputs.agenix.nixosModules.age ];

  age.identityPaths = builtins.catAttrs "path" config.services.openssh.hostKeys;
}
