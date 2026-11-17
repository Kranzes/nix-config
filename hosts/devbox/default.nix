{
  inputs,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./home
    inputs.srvos.nixosModules.server
    "${modulesPath}/profiles/perlless.nix"
  ];

  time.timeZone = "UTC";

  users.users.kranzes.shell = pkgs.zsh;

  security.run0.wheelNeedsPassword = false;

  networking.timeServers = [ "169.254.169.123" ];

  system.stateVersion = "26.11";
}
