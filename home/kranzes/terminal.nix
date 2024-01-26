{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.WINIT_X11_SCALE_FACTOR = "1";
      font = {
        normal.family = "JetBrains Mono";
        size = 9;
      };
      import = [
        (pkgs.fetchurl {
          url = "https://github.com/catppuccin/alacritty/raw/832787d6cc0796c9f0c2b03926f4a83ce4d4519b/catppuccin-macchiato.toml";
          hash = "sha256-m0Y8OBD9Pgjw9ARwjeD8a+JIQRDboVVCywQS8/ZBAcc=";
        })
      ];
    };
  };
}
