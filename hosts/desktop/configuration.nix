# configuration.nix

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./xorg.nix
    ./home.nix
    ./ssh.nix
    ./server-stuff.nix
  ];
  # Use the systemd-boot
  boot = {
    kernelPackages = pkgs.linuxPackages_5_12;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "desktop";
    bridges.br0.interfaces = [ "enp6s0" ];
    networkmanager = {
      enable = true;
    };
    useDHCP = false;
    interfaces = {
      enp6s0.useDHCP = true;
      br0.useDHCP = true;
    };
    firewall = {
      allowedUDPPorts = [ 6600 443 80 8096 8888 3000 19999 4443 10000 9091 ];
      allowedTCPPorts = [ 6600 443 80 8096 8888 3000 19999 4443 10000 9091 ];
      allowedUDPPortRanges = [{ from = 51001; to = 51250; }];
      allowedTCPPortRanges = [{ from = 51001; to = 51250; }];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  nix = {
    package = pkgs.nixUnstable;
    trustedUsers = [ "kranzes" ];
    extraOptions = "experimental-features = nix-command flakes";
  };


  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];


  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    tree
    htop
  ];

  # fonts
  fonts.fonts = with pkgs; [
    jetbrains-mono
    roboto
    font-awesome
    corefonts
    vistafonts
    noto-fonts-cjk
    noto-fonts-emoji
    culmus
  ];

  # List services that you want to enable:
  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    ratbagd.enable = true;
    upower.enable = true;
    udev.packages = [ pkgs.via ];
  };


  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  hardware.pulseaudio.enable = false;
  sound.enable = false;

  # enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # virtualization related stuff
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemuOvmf = true;
      qemuRunAsRoot = true;
    };
    podman = {
      enable = true;
      enableNvidia = true;
      dockerCompat = true;
    };
  };

  users.users.kranzes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "mpd" "libvirtd" "adbusers" ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  programs.fuse.userAllowOther = true;
  programs.adb.enable = true;
  programs.command-not-found.enable = false;
  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    settings = {
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        nv_powermizer_mode = 1;
        ioprio = 0;
      };
      custom = {
        start = "''${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "''${pkgs.libnotify}/bin/notify-send 'GameMode stopped'";
      };
    };
  };
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  # security related stuff
  security = {
    pam.services.lightdm.enableGnomeKeyring = true;
  };

  # remove bloatware (NixOS HTML file)
  documentation.nixos.enable = false;


  system.stateVersion = "20.09";

}
