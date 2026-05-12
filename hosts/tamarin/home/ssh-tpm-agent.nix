{ lib, config, ... }:
{
  services.ssh-tpm-agent.enable = true;

  systemd.user.services.ssh-tpm-agent.Service = {
    ExecStart = lib.mkForce [
      ""
      "${lib.getExe config.services.ssh-tpm-agent.package} --confirm-loaded"
    ];
    Environment = [
      "SSH_ASKPASS=${config.home.sessionVariables.SSH_ASKPASS}"
    ];
  };
}
