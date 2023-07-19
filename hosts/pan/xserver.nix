{
  services.xserver = {
    windowManager.bspwm.enable = true;
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
  };
}
