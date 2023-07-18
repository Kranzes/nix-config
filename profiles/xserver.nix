{ lib, ... }:

{
  services.xserver = {
    enable = true;
    # Hebrew keyboard.
    layout = lib.mkDefault "us,il";
    xkbOptions = lib.mkDefault "grp:lalt_lshift_toggle";
    # Disable mouse acceleration.
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };
      touchpad = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };
    };
  };
}
