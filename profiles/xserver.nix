{ lib, ... }:

{
  services.xserver = {
    enable = true;
    # Hebrew keyboard.
    xkb.layout = lib.mkDefault "us,il";
    xkb.options = lib.mkDefault "grp:lalt_lshift_toggle";
  };

  services.libinput = {
    enable = true;
    mouse = {
      # Disable mouse acceleration.
      accelProfile = "flat";
      accelSpeed = "0";
      middleEmulation = false;
    };
    touchpad = {
      disableWhileTyping = true;
      clickMethod = "clickfinger";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
