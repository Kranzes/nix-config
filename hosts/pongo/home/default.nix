{ pkgs, lib, ... }:

{
  home-manager.users.kranzes = {
    imports = [
      ./music.nix
      ./gaming.nix
    ];

    # Overrides.
    xsession.windowManager.bspwm.startupPrograms = [
      "${lib.getExe pkgs.feh} --no-fehbg --bg-scale $HOME/Wallpapers/pexels-pok-rie.jpg"
    ];
    programs.alacritty.settings.font.size = lib.mkForce 8;
  };
}
