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
    signing = {
      format = "ssh";
      key =
        if config.services.ssh-tpm-agent.enable then "~/.ssh/id_ecdsa.pub" else "~/.ssh/id_ed25519_sk.pub";
      signByDefault = true;
    };
    ignores = [
      "*.swp"
      "result"
    ];
    settings = {
      user.name = "Ilan Joselevich";
      user.email = "personal@ilanjoselevich.com";
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
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
    pkgs.tuicr
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.maiao
  ];

  xdg.configFile."tuicr/config.toml".source = (pkgs.formats.toml { }).generate "tuicr-config.toml" {
    theme = "catppuccin-${config.catppuccin.flavor}";
  };
}
