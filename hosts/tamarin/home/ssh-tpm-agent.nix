{
  pkgs,
  config,
  ...
}:
{
  services.ssh-tpm-agent = {
    enable = true;
    package = pkgs.ssh-tpm-agent.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "Kranzes";
        repo = "ssh-tpm-agent";
        rev = "7406e54ed6827191c58312454f35a9e233f6910b";
        hash = "sha256-5Y6BfR532lM6FxE8vwzhOWdaxvA+cRcEAv+J+DeVTvo=";
      };
      preCheck = ''
        rm cmd/scripts_test.go
      '';
    };
    extraArgs = [ "--confirm-loaded" ];
  };

  systemd.user.services.ssh-tpm-agent.Service.Environment = [
    "SSH_ASKPASS=${config.home.sessionVariables.SSH_ASKPASS}"
  ];
}
