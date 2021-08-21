# configuration.nix

{ config, pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./xorg.nix
    ./home
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
    hostName = "t430";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      wlp3s0.useDHCP = true;
      enp0s25.useDHCP = true;
    };
    firewall = {
      checkReversePath = false;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # enable  unfree software
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    trustedUsers = [ "kranzes" ];
    extraOptions = "experimental-features = nix-command flakes";
  };

  environment.pathsToLink = [ "/share/zsh" ];


  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    tree
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
    upower.enable = true;
    thinkfan.enable = true;
    gvfs.enable = true;
    autorandr.enable = true;
    tlp.enable = true;
    tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = "1";
      CPU_BOOST_ON_BAT = "1";
      WIFI_PWR_ON_BAT = "no";
      DEVICES_TO_DISABLE_ON_DOCK = "wifi";
      DEVICES_TO_ENABLE_ON_UNDOCK = "wifi";
      SOUND_POWER_SAVE_ON_BAT = "0";
    };
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

  users.users.kranzes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "adbusers" ];
    shell = pkgs.zsh;
    uid = 1000;
  };

  programs.light.enable = true;
  programs.adb.enable = true;
  programs.command-not-found.enable = false;
  programs.dconf.enable = true;
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };


  # Unlock keyring on lightdm login.
  security.pam.services.lightdm.enableGnomeKeyring = true;

  # remove bloatware (NixOS HTML file)
  documentation.nixos.enable = false;

  system.stateVersion = "20.09";
}
