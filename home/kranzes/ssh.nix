{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks."cl.snix.dev" = {
      identityFile = "~/.ssh/fuckgerrit";
      port = 29418;
    };
  };
}
