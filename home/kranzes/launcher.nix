{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ rofi ];

  home.file.".config/rofi/config.rasi".text = ''
    configuration {
    font: "JetBrains Mono 8";
    location: 0;
    matching: "fuzzy";
    modi: "drun";
    show-icons: false;
    xoffset: 0;
    yoffset: 0;
    }
    @theme "~/.config/rofi/theme.rasi"
  '';

  home.file.".config/rofi/theme.rasi".text = let inherit (config.colorscheme) colors; in
    ''
      * {
           background:                  #${colors.base01};
           foreground:                  #${colors.base06};
           selected-normal-foreground:  @foreground;
           normal-foreground:           @foreground;
           alternate-normal-background: @background;
           selected-urgent-foreground:  @foreground;
           urgent-foreground:           @foreground;
           alternate-urgent-background: @background;
           active-foreground:           @foreground;
           selected-active-foreground:  @foreground;
           alternate-active-background: @background;
           bordercolor:                 #${colors.base0C};
           alternate-normal-foreground: @foreground;
           normal-background:           @background;
           selected-normal-background:  #${colors.base03};
           border-color:                @bordercolor;
           spacing:                     2;
           separatorcolor:              @background;
           urgent-background:           @background;
           selected-urgent-background:  #${colors.base02};
           alternate-urgent-foreground: @urgent-foreground;
           background-color:            @background;
           alternate-active-foreground: @active-foreground;
           active-background:           @background;
           selected-active-background:  #${colors.base02};
        }

      //----------------------
      // Style
      //----------------------

      #window {
          background-color: @background;
      }

      #mainbox {
          border:  3;
          padding: 10 ;
      }

      #message {
          border:       2px 2px 2px ;
          border-color: @separatorcolor;
          padding:      10 ;
      }

      #textbox {
          text-color: @foreground;
      }

      #listview {
          fixed-height: 0;
          padding:    5 0 0;
          spacing:      5px ;
      }

      #element {
          border:  0;
          padding: 5 0 2 ;
      }

      #element.normal.normal {
          background-color: @normal-background;
          text-color:       @normal-foreground;
      }

      #element.normal.urgent {
          background-color: @urgent-background;
          text-color:       @urgent-foreground;
      }

      #element.normal.active {
          background-color: @active-background;
          text-color:       @active-foreground;
      }

      #element.selected.normal {
          background-color: @selected-normal-background;
          text-color:       @selected-normal-foreground;
      }

      #element.selected.urgent {
          background-color: @selected-urgent-background;
          text-color:       @selected-urgent-foreground;
      }

      #element.selected.active {
          background-color: @selected-active-background;
          text-color:       @selected-active-foreground;
      }

      #element.alternate.normal {
          background-color: @alternate-normal-background;
          text-color:       @alternate-normal-foreground;
      }

      #element.alternate.urgent {
          background-color: @alternate-urgent-background;
          text-color:       @alternate-urgent-foreground;
      }

      #element.alternate.active {
          background-color: @alternate-active-background;
          text-color:       @alternate-active-foreground;
      }

      #element-text, element-icon {
          background-color: inherit;
          text-color:       inherit;
      }

      #button.selected {
          background-color: @selected-normal-background;
          text-color:       @selected-normal-foreground;
      }

      #inputbar {
          spacing:    5;
          text-color: @normal-foreground;
          padding:    5px ;
          border:  0 0 1;
          border-color: @separatorcolor;
      }

      #case-indicator {
          spacing:    0;
          text-color: @normal-foreground;
      }

      #entry {
          spacing:    0;
          text-color: @normal-foreground;
      }

      #prompt {
          spacing:    0;
          text-color: @normal-foreground;
      }

      listview { lines: 8; }
      window { width: 25%; }
    '';
}
