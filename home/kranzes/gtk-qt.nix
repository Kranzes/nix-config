{ pkgs, config, ... }:

{
  xdg.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Roboto";
      size = 10;
      package = pkgs.roboto;
    };
    theme = {
      name = "Catppuccin-GTK-Purple-Dark-Compact-Macchiato";
      package = pkgs.magnetic-catppuccin-gtk.override {
        size = "compact";
        accent = [ "purple" ];
        tweaks = [ config.catppuccin.flavor ];
      };
    };

    gtk4.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
      gtk-enable-event-sounds=0
      gtk-enable-input-feedback-sounds=0
    '';
  };
}
