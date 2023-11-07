{ lib, ... }:

{
  home-manager.users.kranzes = {
    imports = [
      ./bspwm.nix
    ];
    services.sxhkd.keybindings."XF86MonBrightness{Up,Down}" = "light -{A,U} 10";
    services.batsignal.enable = true;
    services.polybar.script = lib.mkForce ''
      polybar rightbar &
      polybar leftbar &
    '';
  };
}
