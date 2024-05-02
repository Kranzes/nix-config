{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks."code.tvl.fyi" = {
      identityFile = "~/.ssh/fuckgerrit";
      port = 29418;
    };
  };
}
