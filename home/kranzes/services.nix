{ config, pkgs, ... }:

{
  services = {
    nextcloud-client.enable = true;
    nextcloud-client.startInBackground = true;
    network-manager-applet.enable = true;
  };

  systemd.user.sockets.yubikey-touch-detector = {
    Unit.Description = "Unix socket activation for YubiKey touch detector service";
    Socket = {
      ListenStream = "%t/yubikey-touch-detector.socket";
      RemoveOnStop = true;
    };
    Install.WantedBy = [ "sockets.target" ];
  };

  systemd.user.services.yubikey-touch-detector = {
    Unit = {
      Description = "Detects when your YubiKey is waiting for a touch";
      Requires = "yubikey-touch-detector.socket";
    };
    Service = {
      ExecStart = "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector --libnotify";
      EnvironmentFile = "-%E/yubikey-touch-detector/service.conf";
    };
    Install = {
      Also = "yubikey-touch-detector.socket";
      WantedBy = [ "default.target" ];
    };
  };
}

