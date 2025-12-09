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
}
