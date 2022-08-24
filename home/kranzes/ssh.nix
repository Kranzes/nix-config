{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks = { "git.ts.platonic.systems".identityFile = "~/.ssh/id_gitlab"; };
  };
}
