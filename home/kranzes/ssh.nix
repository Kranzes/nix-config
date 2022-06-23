{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks =
      let minions = { user = "deploy"; identityFile = "~/.ssh/id_deploy"; }; in
      lib.genAttrs [ "oracle-amd" "oracle-amd2" "oracle-ampere" "vultr" ] (_: minions)
      //
      { "git.ts.platonic.systems".identityFile = "~/.ssh/id_gitlab"; };
  };
}
