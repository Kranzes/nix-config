{ pkgs, ... }:

{

  home.packages = with pkgs; [
    wget
    nemo
    budslink
    virt-manager
    keepassxc
    yt-dlp
    p7zip
    killall
    libnotify
    wl-clipboard
    grim
    slurp
    calc
    mpv
    imv
    htop
    ranger
    pulsemixer
    tree
    gnome-disk-utility
    nextcloud-client
    lm_sensors
    ffmpegthumbnailer
    ffmpeg
    piper
    thunderbird-bin
    ookla-speedtest
    nixpkgs-review
    nix-update
    acpi
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    signal-desktop
    fractal
    yubioath-flutter
    jellyfin-desktop
    kubectl
    git-open
  ];
}
