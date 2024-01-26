{ pkgs, ... }:

{

  home.packages = with pkgs; [
    wget
    cinnamon.nemo
    virt-manager
    keepassxc
    yt-dlp
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
    gnome.gnome-disk-utility
    nextcloud-client
    lm_sensors
    ffmpegthumbnailer
    ffmpeg
    piper
    thunderbird-bin
    ookla-speedtest
    nixpkgs-fmt
    nixpkgs-review
    nix-update
    acpi
    ripgrep
    fd
    sd
    discord
  ];
}

