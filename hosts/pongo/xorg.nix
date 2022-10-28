{ pkgs, ... }:

{
  services.xserver = {
    displayManager = {
      lightdm.background = "${pkgs.fetchurl { url = "https://i.redd.it/4lkkunczgov61.jpg"; sha256 = "1v1c00xzn1gczp05bwg2dval116cq5qbz20gafw5d9hrlb0b4yzg"; }}";
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --rate 240 --mode 1920x1080
        ${pkgs.xcalib}/bin/xcalib /home/kranzes/.xcalib/asus_rog_swift_pg258q.icc
      '';
    };
    videoDrivers = [ "nvidia" ];
    deviceSection = ''
      Option "Coolbits" "28"
    '';
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
      mouse.middleEmulation = false;
    };
  };
}
