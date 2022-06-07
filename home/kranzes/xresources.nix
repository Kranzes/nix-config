{ config, pkgs, ... }:

{
  xresources.extraConfig = ''
    ! special
    *.foreground:   #D8DEE9
    *.background:   #2E3440
    *.cursorColor:  #D8DEE9
    *fading: 35
    *fadeColor: #4C566A
    
    ! black
    *.color0: #3B4252
    *.color8: #4C566A
    
    ! red
    *.color1: #BF616A
    *.color9: #D08770
    
    ! green
    *.color2: #A3BE8C
    *.color10: #A3BE8C
    
    ! yellow
    *.color3: #EBCB8B
    *.color11: #EBCB8B
    
    ! blue
    *.color4: #5E81AC
    *.color12: #81A1C1
    
    ! magenta
    *.color5: #B48EAD
    *.color13: #B48EAD
    
    ! cyan
    *.color6: #88C0D0
    *.color14: #8FBCBB
    
    ! white
    *.color7: #E5E9F0
    *.color15: #ECEFF4
  '';
}    
