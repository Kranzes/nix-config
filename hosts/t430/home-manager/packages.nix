{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    sxhkd
    rofi
    firefox
    discord
    element-desktop
    cinnamon.nemo
    virt-manager
    xorg.xrandr
    keepassxc
    acpi
    upower
    youtube-dl
    gotop
    htop
    p7zip
    xorg.xrdb
    tdesktop
    killall
    xclip
    maim
    mpv
    calc
    dunst
    libnotify
    ranger
    ueberzug
    pulsemixer
    xorg.xcursorthemes
    jitsi-meet-electron
    nextcloud-client
    filezilla
    gnome3.gnome-disk-utility
    lm_sensors
    xdg_utils
    xorg.xprop
    xorg.xwininfo
    xdotool
    psmisc
    networkmanager-openvpn
    ffmpegthumbnailer
    xdo
    jq
    ffmpeg-full
    feh
    networkmanagerapplet
    piper
    libreoffice-fresh
    zathura
    thunderbird
  ];

}

