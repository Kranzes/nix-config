{ config, pkgs, ... }:
{

    xsession = {
      enable = true;
      windowManager.bspwm = {
        enable = true;
        startupPrograms = [
          "sxhkd"
          "${pkgs.feh}/bin/feh --no-fehbg --bg-scale $HOME/Wallpapers/nord-lake.png"
          "dunst"
          "nextcloud --background"
          "pgrep -fl '$HOME/MyScripts/pidswallow -gl' || $HOME/MyScripts/pidswallow -gl"
        ];
        extraConfig = ''
          # pidswallow
          export PIDSWALLOW_SWALLOW_COMMAND='bspc node $pwid --flag hidden=on'
          export PIDSWALLOW_VOMIT_COMMAND='bspc node $pwid --flag hidden=off'
          export PIDSWALLOW_PREGLUE_HOOK='bspc query -N -n $pwid.floating >/dev/null && bspc node $cwid --state floating'
        '';
        monitors = { LVDS1 = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X" ]; };
        settings = {
          remove_disabled_monitors = true;
          remove_unplugged_monitors = true;
          focused_border_color = "#88C0D0";
          border_width = 2;
          window_gap = 15;
        };
        rules = {
          "Zathura" = {
            state = "tiled";
          };
        };
      };
    };

#
    #services.sxhkd = {
      #enable = true;
      #keybindings = {
                #
        ##
        ## wm independent hotkeys
        ##
        #
        #
        ## terminal emulator
        #"super + Return" = "alacritty";
        #
        ## program launcher
        #"super + @space" = "rofi -show drun";
        #
        ## Reload sxhkdrc
        #"super + shift + r" = "pkill -usr1 -x sxhkd; notify-send 'sxhkd' 'Reloaded config'";
        #
        ##
        ## bspwm hotkeys
        ##
        #
        ## quit/restart bspwm
        #"super + alt + {q,r}" = "bspc {quit,wm -r}";
        #
        ## close and kill
        #"super + {_,shift + }w" = "bspc node -{c,k}";
        #
        ## alternate between the tiled and monocle layout
        #"super + m" = "bspc desktop -l next";
        #
        ## send the newest marked node to the newest preselected node
        #"super + y" = "bspc node newest.marked.local -n newest.!automatic.local";
        #
        ## swap the current node and the biggest node
        #"super + g" = "bspc node -s biggest";
        #
        ##
        ## state/flags
        ##
        #
        ## set the window state
        #"super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
        #
        ## set the node flags
        #"super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";
        #
        ##
        ## focus/swap
        ##
        #
        ## focus the node in the given direction
        #"super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
        #
        ## focus the node for the given path jump
        #"super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";
        #
        ## focus the next/previous node in the current desktop
        #"super + {_,shift + }c" = "bspc node -f {next,prev}.local.!hidden.window";
        #
        ## focus the next/previous desktop in the current monitor
        #"super + bracket{left,right}" = "bspc desktop -f {prev,next}.local.!hidden.window";
        #
        ## focus the last node/desktop
        #"super + {grave,Tab}" = "bspc {node,desktop} -f last";
        #
        ## focus the older or newer node in the focus history
        #"super + {o,i}" = ''
          #bspc wm -h off; \ 
          #bspc node {older,newer} -f; \
          #bspc wm -h on";
        #'';
        #
        ## focus or send to the given desktop
        #"super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
        #
        ##
        ## preselect
        ##
        #
        ## preselect the direction
        #"super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
        #
        ## preselect the ratio
        #"super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
        #
        ## cancel the preselection for the focused node
        #"super + ctrl + space" = "bspc node -p cancel";
        #
        ## cancel the preselection for the focused desktop
        #"super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
        #
        ##
        ## move/resize
        ##
        #
        ## Expand/contract a window by moving one of its side outward/inward
        #"super + alt + {h,j,k,l}" = ''
          #STEP=20; SELECTION={1,2,3,4}; \
          #bspc node -z $(echo 'left -$STEP 0,bottom 0 $STEP,top 0 -$STEP,right $STEP 0' | cut -d',' -f$SELECTION) || \
          #bspc node -z $(echo 'right -$STEP 0,top 0 $STEP,bottom 0 -$STEP,left $STEP 0' | cut -d',' -f$SELECTION)
        #'';
        #
        ## move a floating window
        #"super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
        #
        ## Rotate tree
        #"super + shift + {d,a}" = "bspc node @/ -C {forward,backward}";
        #
        #
        ##### MULTIMEDIA KEYS ####
        #
        #"XF86Audio{Prev,Next,Play}" = "mpc -q {prev,next,toggle}";
        #
        #"XF86AudioLowerVolume" = "pactl -- set-sink-volume 0 -5%";
        #
        #"XF86AudioRaiseVolume" = "pactl -- set-sink-volume 0 +5%";
        #
        #"XF86AudioMute" = "pactl set-sink-mute 0 toggle";
        #
        #"XF86AudioMicMute" = "pactl set-source-mute 1 toggle";
        #
        #"XF86MonBrightnessDown" = "light -U 10";
        #
        #"XF86MonBrightnessUp" = "light -A 10";
        #
        ##### Launch Programs ####
        #"alt + 1" = "firefox";
        #
        #"alt + 2" = "Discord";
        #
        #"alt + 3" = "nemo";
        #
        #"alt + 4" = "alacritty -e ncmpcpp";
        #
        #"super + alt + m" = "'/home/kranzes/My Scripts/rofi-mpd' -a";
        #
        ##### MAIM ####
        #"ctrl + Print" = "maim -s | xclip -selection clipboard -t image/png";
        #
        #"Print" = "maim | xclip -selection clipboard -t image/png && notify-send 'maim' 'Screenshot captured'";
#
      #};
    #};


}
