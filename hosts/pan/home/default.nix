{
  home-manager.users.kranzes = {
    imports = [
      ./bspwm.nix
      ./shell.nix
      ./keyboard.nix
    ];
    services.mpd.musicDirectory = "/home/kranzes/Music";
  };
}
