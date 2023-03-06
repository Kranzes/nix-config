{
  imports = [
    ./hardware-configuration.nix
    ./hercules-ci.nix
    ./impermanence.nix
    ./devel.nix
  ];

  users.mutableUsers = false;

  programs.vim.defaultEditor = true;

  environment.noXlibs = true;

  documentation.nixos.enable = false;

  services.openssh.hostKeys = [{
    path = "/etc/ssh/ssh_host_ed25519_key";
    type = "ed25519";
    rounds = 100;
  }];

  security.sudo.wheelNeedsPassword = false;

  users.users.kranzes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBF2qWuvMCuJMlc6+ehyU0V/asmfAlT5/GLhUQqbpQ/bAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEVpaQ0K0Fzz0Hu48pqKiI25lr9ASwXR1yzYbeErBX/2AAAABHNzaDo="
    ];
  };
}
