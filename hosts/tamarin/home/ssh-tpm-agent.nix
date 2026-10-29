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
        owner = "Foxboron";
        repo = "ssh-tpm-agent";
        rev = "43795283993ef79015729399bdecf413fb7705d8";
        hash = "sha256-l6KNW3jgCcIniolyHx1Ijf3cQ0K6iFPdBqbsjcUpjfk=";
      };
      preCheck = ''
        rm cmd/scripts_test.go
      '';
    };
    extraArgs = [ "--confirm-loaded" ];
  };

  systemd.user.services.ssh-tpm-agent.Service.Environment = [
    "SSH_ASKPASS=${config.home.sessionVariables.SSH_ASKPASS}"
    "SSH_ASKPASS_REQUIRE=force"
  ];
}
