{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    ignores = [
      "*.swp"
      "result"
    ];
    settings = {
      user.name = "Ilan Joselevich";
      user.email = "personal@ilanjoselevich.com";
      init.defaultBranch = "master";
      commit.gpgSign = true;
      tag.gpgSign = true;
      gpg.format = "ssh";
      user.signingKey =
        if config.services.ssh-tpm-agent.enable then "~/.ssh/id_ecdsa.pub" else "~/.ssh/id_ed25519_sk.pub";
      push.autoSetupRemote = true;
      init.templateDir = "${
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maiao
      }/share/git-core/templates";
      maiao.autoInstallHook = true;
      credential."https://api.github.com".helper = "${pkgs.writeShellScript "gh-api-credential" ''
        ${pkgs.gnused}/bin/sed 's/^host=api\.github\.com$/host=github.com/' | ${lib.getExe config.programs.gh.package} auth git-credential "$@"
      ''}";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      version = 1;
    };
  };

  home.packages = [
    pkgs.git-open
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maiao
  ];
}
