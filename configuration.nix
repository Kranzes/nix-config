# configuration.nix

{ config, pkgs, lib, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./xorg.nix
    ./home.nix
    ./ssh.nix
    ./nvim.nix
   # ./server-stuff.nix
    (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz}/nixos")
  ];
  # Use the systemd-boot
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "desktop";
    bridges.br0.interfaces = [ "enp6s0" ];
    networkmanager = {
      enable = false;
    };
    useDHCP = true;
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

  nix.trustedUsers = [ "kranzes" ];


  # enable unstable and unfree software
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];


  environment.systemPackages = with pkgs; [
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
    culmus
  ];



  # List services that you want to enable:
  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    ratbagd.enable = true;
    upower.enable = true;
  };


  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # virtualization related stuff
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    qemuOvmf = true;
    qemuRunAsRoot = true;
  };

  users.users.kranzes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "mpd" "libvirtd" "adbusers" ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  programs.fuse.userAllowOther = true;
  programs.adb.enable = true;
  programs.bash.shellAliases = { nixe = "sudo nvim /etc/nixos/configuration.nix"; };
  programs.command-not-found.enable = false;
  programs.dconf.enable = true;
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
    promptInit = "RPROMPT=";
  };


  # security related stuff
  security = {
    pam.services.lightdm.enableGnomeKeyring = true;
  };

  # remove bloatware (NixOS HTML file)
  documentation.nixos.enable = false;

  system.stateVersion = "20.09";

}
