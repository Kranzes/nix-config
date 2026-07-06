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
}
