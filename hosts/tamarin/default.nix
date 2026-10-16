{ inputs, pkgs, ... }:

let
  btd700ctl = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.btd700ctl;
in

{
  imports = [
    ./hardware-configuration.nix
    ./home
    inputs.self.nixosModules.hosted-podman
  ]
  ++ (with inputs.self.nixosModules; [
    profiles-android
    profiles-audio
    profiles-laptop
    profiles-hyprland
  ]);

  services.udev.packages = [ btd700ctl ];

  systemd.packages = [ btd700ctl ];
  systemd.user.services.btd700d = {
    wantedBy = [ "default.target" ];
    bindsTo = [ "dev-btd700.device" ];
    after = [ "dev-btd700.device" ];
  };

  system.etc.overlay.enable = true;

  time.timeZone = null; # Set manually, because I travel often.

  system.stateVersion = "25.11";
}
