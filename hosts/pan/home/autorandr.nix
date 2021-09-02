{ config, pkgs, ... }:


{

  programs.autorandr = {
    enable = true;
    profiles = {
      "docked" = {
        fingerprint = {
          DP1 = "00ffffffffffff0006b3b12531620200231c0104a5361e7806ee91a3544c99260f505421080001010101010101010101010101010101023a801871382d40582c4500202f2100001e000000ff002341534d796155477735567664000000fd001ef043ff38010a202020202020000000fc00524f47205047323538510a202001fe020312412309070183010000654b04000101fe5b80a07038354030203500202f2100001a866f80a07038404030203500202f2100001a5a8780a070384d4030203500202f2100001a40b980a070383c4030203a00202f2100001e80d980507038504008203a00202f2100001e000000000000000000000000000000000000005e";
          LVDS1 = "00ffffffffffff0006af3c310000000000140103801f11780a10b597585792261e505400000001010101010101010101010101010101121b5646500023302616360035ad100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343058544e30332e31200a0026";
        };
        config = {
          LVDS1.enable = false;
          DP1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            rate = "144.00";
          };
        };
        hooks.postswitch = ''
          ${pkgs.xcalib}/bin/xcalib $HOME/.xcalib/asus_rog_swift_pg258q.icc
          bspc monitor DP1 -d 1 2 3 4 5 6 7 8 9 10
          ${pkgs.feh}/bin/feh --no-fehbg --bg-scale $HOME/Wallpapers/nord-lake.png
          systemctl restart polybar --user
        '';
      };
      "mobile" = {
        fingerprint = {
          LVDS1 = "00ffffffffffff0006af3c310000000000140103801f11780a10b597585792261e505400000001010101010101010101010101010101121b5646500023302616360035ad100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343058544e30332e31200a0026";
        };
        config = {
          DP1.enable = false;
          LVDS1 = {
            enable = true;
            primary = true;
            mode = "1366x768";
            rate = "60.00";
          };
        };
        hooks.postswitch = ''
          ${pkgs.xcalib}/bin/xcalib --clear $HOME/.xcalib/asus_rog_swift_pg258q.icc
          bspc monitor LVDS1 -d 1 2 3 4 5 6 7 8 9 10
          ${pkgs.feh}/bin/feh --no-fehbg --bg-scale $HOME/Wallpapers/nord-lake.png
          systemctl restart polybar --user
        '';
      };
    };
  };

}

