{
  pkgs,
  config,
  ...
}:
{
  services.ssh-tpm-agent = {
    enable = true;
    package = pkgs.ssh-tpm-agent.overrideAttrs {
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/Foxboron/ssh-tpm-agent/commit/b49c37f6dd11781d0c0cb696ac0bd37d1f353a49.patch";
          hash = "sha256-QBZTclT3UZMKGJ9YKF67r03tOpRonJ/ww9tGePpjJmM=";
        })
      ];
    };
    extraArgs = [ "--confirm-loaded" ];
  };

  systemd.user.services.ssh-tpm-agent.Service.Environment = [
    "SSH_ASKPASS=${config.home.sessionVariables.SSH_ASKPASS}"
  ];
}
