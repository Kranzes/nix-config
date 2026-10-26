{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  services = {
    nextcloud-client.enable = true;
    nextcloud-client.startInBackground = true;
    gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };
    gpg-agent = {
      enable = true;
      enableScDaemon = false;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };

  systemd.user.services.btd700-control = {
    Unit = {
      Description = "BTD 700 Control tray";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${
        lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.btd700-control
      } --background";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
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
      ExecStart = "${lib.getExe pkgs.yubikey-touch-detector} --libnotify";
      EnvironmentFile = "-%E/yubikey-touch-detector/service.conf";
    };
    Install = {
      Also = "yubikey-touch-detector.socket";
      WantedBy = [ "default.target" ];
    };
  };
}
