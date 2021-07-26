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
    youtube-dl
    gotop
    p7zip
    tdesktop
    killall
    xclip
    maim
    calc
    mpv
    feh
    htop
    ranger
    pulsemixer
    tree
    fzf
    filezilla
    gnome3.gnome-disk-utility
    nextcloud-client
    lm_sensors
    libreoffice
    ffmpegthumbnailer
    ffmpeg
    piper
    thunderbird-bin
    firefox-bin
    openrgb
    hunspellDicts.en-us
    hunspellDicts.he-il
    vial
    ookla-speedtest
    (pkgs.callPackage ../custom-packages/freezer { })
    (pkgs.callPackage ../custom-packages/bspswallow { })
  ];




}

