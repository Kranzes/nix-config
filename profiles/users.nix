{
  pkgs,
  lib,
  config,
  ...
}:

let
  isZshSetForUsers = lib.elem "zsh" (
    lib.mapAttrsToList (_: p: lib.getName p.shell) config.users.users
  );
in
{
  users.users.kranzes = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ]
    ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"
    ++ lib.optional config.networking.networkmanager.enable "networkmanager"
    ++ lib.optional config.virtualisation.podman.enable "podman"
    ++ lib.optional config.services.home-assistant.enable "dialout"
    ++ lib.optional config.programs.gamemode.enable "gamemode"
    ++ lib.optional config.security.tpm2.enable config.security.tpm2.tssGroup;
    shell = lib.mkIf config.services.graphical-desktop.enable pkgs.zsh; # I only care for ZSH on non-servers
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAII2I2zQbQssSudF8DveLSKEhM/EQtReUsO+kxIf/dq5sAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEVpaQ0K0Fzz0Hu48pqKiI25lr9ASwXR1yzYbeErBX/2AAAABHNzaDo="
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBImkj4Y1nZt4bbFKGMw9p+VFOaOdVwyrDV8zkqN4AtbiNJkNKShG0L9NzgN5uzb1DlWY8vI5TNZeNyy57/O08z0= kranzes@tamarin"
    ];
  };

  # Needed to make completion available to home-manager.
  environment.pathsToLink = lib.optional isZshSetForUsers "/share/zsh";
  programs.zsh = {
    enable = isZshSetForUsers;
    enableGlobalCompInit = false;
  };
}
