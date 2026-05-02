{ inputs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell.enable = true;

  xdg.configFile."noctalia/plugins/ssh-askpass".source =
    "${inputs.mic92-noctalia-plugins}/ssh-askpass";
}
