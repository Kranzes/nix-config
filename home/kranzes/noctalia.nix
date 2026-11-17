{ inputs, pkgs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      calendarSupport = true;
    };
  };

  xdg.configFile."noctalia/plugins/ssh-askpass".source =
    "${inputs.mic92-noctalia-plugins}/ssh-askpass";

  home.file.".face".source = pkgs.fetchurl {
    url = "https://github.com/Kranzes.png";
    hash = "sha256-Am+xMAXUU7LlbsL62JyFYiNp30HktjZ5FZcD4ZhWTZU=";
  };
}
