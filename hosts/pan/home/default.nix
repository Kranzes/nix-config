{
  home-manager.users.kranzes = {
    imports = [
      ./bspwm.nix
      ./shell.nix
      ./keyboard.nix
    ];
    services.batsignal.enable = true;
    services.mpd.musicDirectory = "/home/kranzes/Music";
  };
}
