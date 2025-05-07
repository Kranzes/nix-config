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
    extraGroups =
      [ "wheel" ]
      ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      ++ lib.optional config.programs.light.enable "video"
      ++ lib.optional config.programs.adb.enable "adbusers"
      ++ lib.optional config.virtualisation.docker.enable "docker"
      ++ lib.optional config.services.home-assistant.enable "dialout";
    shell = lib.mkIf config.services.xserver.enable pkgs.zsh; # I only care for ZSH on non-servers
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAII2I2zQbQssSudF8DveLSKEhM/EQtReUsO+kxIf/dq5sAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEVpaQ0K0Fzz0Hu48pqKiI25lr9ASwXR1yzYbeErBX/2AAAABHNzaDo="
    ];
  };

  # Needed to make completion available to home-manager.
  environment.pathsToLink = lib.optional isZshSetForUsers "/share/zsh";
  programs.zsh = {
    enable = isZshSetForUsers;
    enableGlobalCompInit = false;
  };
}
