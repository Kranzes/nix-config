{ config, pkgs, ... }:

{

  programs.git = {
    enable = true;
    userName = "Ilan Joselevich";
    userEmail = "personal@ilanjoselevich.com";
    ignores = [ "*.swp" ];
    extraConfig = {
      init = { defaultBranch = "master"; };
    };
  };

}

