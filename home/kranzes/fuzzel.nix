{
  config,
  pkgs,
  ...
}:
let
  catppuccinInclude = "${config.catppuccin.sources.fuzzel}/catppuccin-${config.catppuccin.fuzzel.flavor}/${config.catppuccin.fuzzel.accent}.ini";
  fuzzelTheme = pkgs.writeText "fuzzel-theme.ini" ''
    include=${catppuccinInclude}
    [colors]
    background=24273aff
  '';
in
{
  # Disabled: catppuccin include breaks user color overrides.
  catppuccin.fuzzel.enable = false;
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMonoNL Nerd Font";
        icons-enabled = false;
        include = "${fuzzelTheme}";
      };
      border = {
        width = 2;
        selection-radius = 10;
      };
    };
  };
}
