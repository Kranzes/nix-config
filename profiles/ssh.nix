{
  services.openssh = {
    enable = true;
    settings = {
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "no";
    };
  };
}
