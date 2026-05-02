{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (inputs.mic92-noctalia-plugins.packages.${pkgs.stdenv.hostPlatform.system})
    noctalia-ssh-askpass
    ;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*".hashKnownHosts = true;
      "cl.snix.dev" = {
        identityFile = "~/.ssh/fuckgerrit";
        port = 29418;
      };
    };
  };

  home.packages = [ noctalia-ssh-askpass ];
  home.sessionVariables.SSH_ASKPASS = lib.getExe noctalia-ssh-askpass;
}
