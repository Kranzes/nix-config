{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hercules-ci.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub.enable = true;

  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "vultr";

  programs.vim.defaultEditor = true;

  services.tailscale.enable = true;

  users.users.kranzes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBF2qWuvMCuJMlc6+ehyU0V/asmfAlT5/GLhUQqbpQ/bAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEVpaQ0K0Fzz0Hu48pqKiI25lr9ASwXR1yzYbeErBX/2AAAABHNzaDo="
    ];
  };

  system.stateVersion = "21.05";
}
