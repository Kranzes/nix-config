{ pkgs, ... }:

{
  programs.git = {
    enable = true;
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
      user.signingKey = "~/.ssh/id_ed25519_sk.pub";
      push.autoSetupRemote = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      version = 1;
    };
  };

  home.packages = [ pkgs.git-open ];
}
