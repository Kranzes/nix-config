{ lib, ... }:

{
  services.xserver = {
    enable = true;
    # Hebrew keyboard.
    xkb.layout = lib.mkDefault "us,il";
    xkb.options = lib.mkDefault "grp:lalt_lshift_toggle";
  };

  # Disable mouse acceleration.
  services.libinput = {
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
