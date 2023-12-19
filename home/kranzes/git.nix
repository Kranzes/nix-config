{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Ilan Joselevich";
    userEmail = "personal@ilanjoselevich.com";
    ignores = [ "*.swp" "result" ];
    extraConfig = {
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
