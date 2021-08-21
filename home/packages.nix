{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    wget
    liquidctl
    cinnamon.nemo
    virt-manager
    keepassxc
    discord
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
    hunspellDicts.en-us
    hunspellDicts.he-il
    vial
    ookla-speedtest
    nixpkgs-fmt
    nixpkgs-review
    nix-update
    acpi
  ];




}

