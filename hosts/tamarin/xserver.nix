{ pkgs, lib, ... }:
{
  services.xserver = {
    windowManager.bspwm.enable = true;
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
      Option "VariableRefresh" "true"
      Option "AsyncFlipSecondaries" "true"
    '';
    dpi = 144;
    displayManager.setupCommands = ''
      ${lib.getExe pkgs.xcalib} /home/kranzes/.xcalib/BOE0CB4.icm
    '';
  };
}
