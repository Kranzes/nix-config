{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks =
      let
        minions = { user = "deploy"; identityFile = "~/.ssh/id_deploy"; };
      in
      {
        "github.com".identityFile = "~/.ssh/id_git";
      } //
      lib.genAttrs [ "oracle-amd" "oracle-amd2" "oracle-ampere" "vultr" ] (_: minions);
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
  };
}
