{
  services.xserver = {
    windowManager.bspwm.enable = true;
    videoDrivers = [ "modesetting" ];
    enableTearFree = true;
  };
}
