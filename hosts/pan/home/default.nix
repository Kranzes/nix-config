{ lib, ... }:

{
  # Overrides.
  home-manager.users.kranzes = {
    services.batsignal.enable = true;
    services.sxhkd.keybindings."XF86MonBrightness{Up,Down}" = "light -{A,U} 10";
    services.polybar.script = lib.mkForce ''
      polybar rightbar &
      polybar leftbar &
    '';
  };
}
