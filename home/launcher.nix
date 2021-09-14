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
    @theme "~/.config/rofi/themes/nord.rasi"
  '';

  home.file.".config/rofi/themes/nord.rasi".text = ''
    * {
            nord0:       #2E3440;
            nord1:        #3B4252;
            nord2:        #434C5E;
            nord3:        #4C566A;
            nord4:        #D8DEE9;
            nord5:         #E5E9F0;
            nord6:         #ECEFF4;
            nord7:        #8FBCBB;
            nord8:          #88C0D0;
            nord9:         #81A1C1;
            nord10:        #5E81AC;
            nord11:        #BF616A;
            nord12:        #D08770;
            nord13:        #EBCB8B;
            nord14:        #A3BE8C;
            nord15:        #B48EAD;
            background:                  @nord1;
            foreground:                  @nord6;
            selected-normal-foreground:  @nord6;
            normal-foreground:           @foreground;
            alternate-normal-background: @nord1;
            selected-urgent-foreground:  @nord6;
            urgent-foreground:           @foreground;
            alternate-urgent-background: @nord1;
            active-foreground:           @foreground;
            selected-active-foreground:  @foreground;
            alternate-active-background: @nord1;
            bordercolor:                 @nord8;
            alternate-normal-foreground: @foreground;
            normal-background:           @background;
            selected-normal-background:  @nord3;
            border-color:                @nord8;
            spacing:                     2;
            separatorcolor:              @nord1;
            urgent-background:           @background;
            selected-urgent-background:  @nord2;
            alternate-urgent-foreground: @urgent-foreground;
            background-color:            @background;
            alternate-active-foreground: @active-foreground;
            active-background:           @background;
            selected-active-background:  @nord2;
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
