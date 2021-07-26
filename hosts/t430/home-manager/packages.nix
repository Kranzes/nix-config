{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    cinnamon.nemo
    virt-manager
    keepassxc
    anki
    acpi
    translate-shell
    discord
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
    jellyfin-media-player
    hunspellDicts.en-us
    hunspellDicts.he-il
    ookla-speedtest
    (pkgs.callPackage ../custom-packages/bspswallow { })
  ];




}

