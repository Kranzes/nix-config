# configuration.nix

{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./xorg.nix
    ./hosted
    ./home
  ];
  # Use the systemd-boot
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    supportedFilesystems = [ "ntfs" ];
    initrd.systemd.enable = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedUDPPorts = [
        80 # HTTP
        443 # HTTPS 
        6600 # MPD 
      ];
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS 
        6600 # MPD 
      ];
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false; # Slows down boot

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  nix.settings.trusted-users = [ "kranzes" ];

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
    fstrim.enable = true;
    pcscd.enable = true;
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
      qemu.ovmf.enable = true;
    };
  };
  programs.extra-container.enable = true;

  users.users.kranzes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "mpd" "libvirtd" "adbusers" ];
    uid = 1000;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBF2qWuvMCuJMlc6+ehyU0V/asmfAlT5/GLhUQqbpQ/bAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEVpaQ0K0Fzz0Hu48pqKiI25lr9ASwXR1yzYbeErBX/2AAAABHNzaDo="
    ];
  };

  programs.adb.enable = true;
  programs.command-not-found.enable = false;
  programs.dconf.enable = true;
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  # security related stuff
  security = {
    pam.services.lightdm.enableGnomeKeyring = true;
  };

  environment.variables.EDITOR = "vim";

  # remove bloatware (NixOS HTML file)
  documentation.nixos.enable = false;

  system.stateVersion = "20.09";
}
