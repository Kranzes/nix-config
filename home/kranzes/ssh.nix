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
    settings = {
      "*".HashKnownHosts = true;
      "cl.snix.dev" = {
        IdentityFile = "~/.ssh/fuckgerrit";
        Port = 29418;
      };
    };
  };

  home.packages = [ noctalia-ssh-askpass ];
  home.sessionVariables.SSH_ASKPASS = lib.getExe noctalia-ssh-askpass;
}
