{ config, pkgs, inputs, ... }:

{

  home.packages = with pkgs; [
    wget
    liquidctl
    cinnamon.nemo
    virt-manager
    keepassxc
    anki
    translate-shell
    yt-dlp
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
    discord
    firefox-bin
    hunspellDicts.en-us
    hunspellDicts.he-il
    vial
    ookla-speedtest
    nixpkgs-fmt
    nixpkgs-review
    nix-update
    acpi
    networkmanagerapplet
    ripgrep
  ];




}

