{ pkgs, lib, ... }:

{
  home-manager.users.kranzes = {
    imports = [
      ./music.nix
      ./gaming.nix
      ./browser.nix
    ];

    # Overrides.
    xsession.windowManager.bspwm.startupPrograms = [
      "${lib.getExe pkgs.feh} --no-fehbg --bg-scale $HOME/Wallpapers/evening-sky.png"
    ];
    programs.alacritty.settings.font.size = lib.mkForce 8;
  };
}
