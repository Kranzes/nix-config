{ pkgs, ... }:

{

  home.packages = with pkgs; [
    wget
    nemo
    virt-manager
    keepassxc
    yt-dlp
    p7zip
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
    gnome-disk-utility
    nextcloud-client
    lm_sensors
    ffmpegthumbnailer
    ffmpeg
    piper
    thunderbird-bin
    ookla-speedtest
    nixfmt-rfc-style
    nixpkgs-review
    nix-update
    acpi
    ripgrep
    fd
    sd
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    signal-desktop
    yubioath-flutter
  ];
}
