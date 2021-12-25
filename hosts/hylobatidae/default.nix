{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hercules.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "hylobatidae";

  time.timeZone = "Asia/Jerusalem";

  environment.systemPackages = with pkgs; [
    wget
    htop
  ];

  users.users.kranzes = {
    isNormalUser = true;
    initialPassword = "ChangeMe";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIxgHstqeTdLimsLRe+cdqv6Sgt/dILCrUqQz6Gtxwb kranzes@pongo" ];
  };

  programs.vim.defaultEditor = true;

  system.stateVersion = "22.05";
}
