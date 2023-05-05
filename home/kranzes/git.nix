{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Ilan Joselevich";
    userEmail = "personal@ilanjoselevich.com";
    ignores = [ "*.swp" ];
    extraConfig = {
      init.defaultBranch = "master";
      commit.gpgSign = true;
      tag.gpgSign = true;
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519_sk.pub";
    };
  };

  home.packages = [ pkgs.git-open ];
}
