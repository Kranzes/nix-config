{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    wget
    discord
    liquidctl
    cinnamon.nemo
    virt-manager
    keepassxc
    anki
    translate-shell
    firefox-bin
    youtube-dl
    gotop
    p7zip
    tdesktop
    killall
    xclip
    maim
    calc
    ranger
    ueberzug
    pulsemixer
    tree
    filezilla
    gnome3.gnome-disk-utility
    nextcloud-client
    lm_sensors
    libreoffice-fresh
    ffmpegthumbnailer
    ffmpeg
    piper
    thunderbird
    openrgb
    jellyfin-media-player
    nixops
    xorg.xprop
    xorg.xev
#    (pkgs.callPackage ../custom-packages/freezer/default.nix { })
  ];




}

